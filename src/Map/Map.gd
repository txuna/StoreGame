extends Node2D


onready var Clock = $Clock
onready var Background = $Background

var DisplayStand = preload("res://src/Map/DisplayStand.tscn")

var held_object = null
var time_gap = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	Clock.get_node("Label").text = State.get_time()
	var clock_timer = Timer.new()
	clock_timer.wait_time = time_gap
	clock_timer.connect("timeout", self, "_on_clock_timeout")
	add_child(clock_timer)
	clock_timer.start()
	
	# 진열대 넘버 설정
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
	
		var display_stand_list = State.get_all_display_stand()
		for id in display_stand_list:
			if id == display_stand.get_display_stand_number():
				plus_btn.visible = false 
				display_stand.visible = true
				display_stand.setup()
				
		index+=1
		
		
func show_display_stand(index):
	for display in $InStore/Displays.get_children():
		var display_stand = display.get_node("DisplayStand")
		var plus_btn = display.get_node("PlusButton")
		if display_stand.get_display_stand_number() == index:
			display_stand.visible = true
			print("SET")
			display_stand.setup()
			plus_btn.visible = false
			
			
	
func _on_clock_timeout():
	State.set_time(time_gap)
	Clock.get_node("Label").text = State.get_time()


func load_product(id, count):
	for i in range(count):
		var instance = Products.get_products()[id]["scene"].instance()
		instance.connect("clicked", self, "_on_product_pickable_clicked")
		instance.setup(id)
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
