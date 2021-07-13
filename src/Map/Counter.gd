extends StaticBody2D


const STATE = 0
const SALES = 1
const STOCK = 2 
const EVENT = 3

signal LoadPosUI 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var posui = get_node("/root/Main/UiLayer/PosUI")
	connect("LoadPosUI", posui, "show_display")


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("LoadPosUI", STATE)
			#get_node("/root/Main/UiLayer/PosUI").show_display()
