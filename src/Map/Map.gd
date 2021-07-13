extends Node2D


onready var Clock = $Clock
onready var Background = $Background



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
	
	#load_product()
	#load_product()
	
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
