extends Node2D


onready var Clock = $Clock
onready var Background = $Background

var state

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
	
	
func _on_clock_timeout():
	State.set_time(time_gap)
	Clock.get_node("Label").text = State.get_time()
