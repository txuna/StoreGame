extends Node2D


onready var Clock = $Clock
onready var Background = $Background

var DisplayStand = preload("res://src/Map/DisplayStand.tscn")

var held_object = null
#var time_gap = 48 # 게임시간 1초에 현실시간 48초가 흐름
var time_gap = 72

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func get_spawn_npc_position():
	return $SpawnNpc.position
	

func setup():	
	show_cash()
	var time = State.get_time()
	var rotation_count = (time["hour"] * 3600 +  time["min"] * 60 + time["sec"]) / 72 #48
	$Background.rotation_degrees = 0.3 * rotation_count
	Clock.get_node("Label2").text = State.get_day()["str"]
	Clock.get_node("Label").text = "{hour}:{min}:{sec}".format({
		"hour" : time["hour"],
		"min" : time["min"],
		"sec" : time["sec"]})
		
	var clock_timer = Timer.new()
	clock_timer.wait_time = 1
	clock_timer.connect("timeout", self, "_on_clock_timeout")
	add_child(clock_timer)
	clock_timer.start()
	
	# 진열대 넘버 설정 및 가지고 있는 진열태 표시
	var index = 1
	for display in $InStore/Displays.get_children():
		var plus_btn = display.get_node("PlusButton")
		var display_stand = display.get_node("DisplayStand")
		display_stand.set_display_stand_number(index)
		plus_btn.set_display_stand_number(index)
		# 진열대 구매 시그널 연결 
		plus_btn.connect("BuyDisplayStand", get_node("/root/Main/Game"),  "_on_buy_display_stand")
		
		plus_btn.visible = true
		display_stand.visible = false
	
		# 소유중인 진열대 체크
		var display_stand_list = State.get_all_display_stand()
		for id in display_stand_list:
			if id == display_stand.get_display_stand_number():
				var productId = display_stand_list[id]["productId"]
				plus_btn.visible = false 
				display_stand.visible = true
				display_stand.setup(productId)
				
				
		index+=1
	load_product_from_save_file()
		
		
# 진열대에 있는 템들을 창고로 올려보내기  - Stock 이용 
func load_product_from_save_file():
	var products = State.get_product_all_index()
	for index in products:
		var product = products[index]
		load_product(index, product["id"])
		

# 특정 진열대를 보여줌
func show_display_stand(index):
	for display in $InStore/Displays.get_children():
		var display_stand = display.get_node("DisplayStand")
		var plus_btn = display.get_node("PlusButton")
		if display_stand.get_display_stand_number() == index:
			display_stand.visible = true
			display_stand.setup()
			plus_btn.visible = false
			

# condition : id, in_display, 
func get_product_in_store(productId, in_display):
	for product in $InStore/Storage.get_children():
		if productId == product.get_id() and in_display == product.is_display():
			return product
			
	return null
	
func _on_clock_timeout():
	$Background.rotation_degrees+=0.3
	if $Background.rotation_degrees >= 360:
		$Background.rotation_degrees = 0

	Clock.get_node("Label2").text = State.get_day()["str"]
	State.set_time(time_gap)
	var time = State.get_time()
	Clock.get_node("Label").text = "{hour}:{min}:{sec}".format({
		"hour" : time["hour"],
		"min" : time["min"],
		"sec" : time["sec"]})

func show_cash():
	$InStore/CashTexture/Cash.text = str(State.get_current_cash()) + "$"

func load_product(index, id):
	var instance = Products.get_products()[id]["scene"].instance()
	instance.connect("clicked", self, "_on_product_pickable_clicked")
	instance.setup(index, $InStore/Delivery.position)
	get_node("InStore/Storage").add_child(instance)
	instance.add_to_group("products")
	instance.position = $InStore/Delivery.position


func _on_product_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null


func _on_Debug_pressed() -> void:
	get_node("/root/Main/UiLayer/DebugTab").show_display()
