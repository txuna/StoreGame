extends Node2D


onready var Clock = $Clock
onready var Background = $Background

var DisplayStand = preload("res://src/Map/DisplayStand.tscn")

var held_object = null
var time_gap = 48 # 게임시간 1초에 현실시간 48초가 흐름

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	show_cash()
	var time = State.get_time()
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
			display_stand_list[id]["count"] = 0
			if id == display_stand.get_display_stand_number():
				var productId = display_stand_list[id]["productId"]
				plus_btn.visible = false 
				display_stand.visible = true
				display_stand.setup(productId)
				
				
		index+=1
	load_product_from_save_file()
		
		
# 진열대에 있는 템들을 창고로 올려보내기  - Stock 이용 
func load_product_from_save_file():
	var stocks = State.get_stock()
	for id in stocks:
		var product = stocks[id]
		load_product(id, product["count"])
		

# 특정 진열대를 보여줌
func show_display_stand(index):
	for display in $InStore/Displays.get_children():
		var display_stand = display.get_node("DisplayStand")
		var plus_btn = display.get_node("PlusButton")
		if display_stand.get_display_stand_number() == index:
			display_stand.visible = true
			display_stand.setup()
			plus_btn.visible = false
			
			
	
func _on_clock_timeout():
	$Background.rotation_degrees+=0.2
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

func load_product(id, count, pos=$InStore/Delivery.position):
	for i in range(count):
		var instance = Products.get_products()[id]["scene"].instance()
		instance.connect("clicked", self, "_on_product_pickable_clicked")
		instance.setup(id)
		get_node("InStore/Storage").add_child(instance)
		instance.add_to_group("products")
		instance.position = pos


func _on_product_pickable_clicked(object):
	if !held_object:
		held_object = object
		held_object.pickup()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if held_object and !event.pressed:
			held_object.drop(Input.get_last_mouse_speed())
			held_object = null
