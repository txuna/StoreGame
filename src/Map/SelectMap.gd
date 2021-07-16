extends TextureRect

const NEW = 0
const CONTINUE = 1

signal GameStart

var region:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	region = "A"


func _on_Exitbtn_pressed() -> void:
	$RegionDetail/TextureRect.visible = false


func _on_StartBtn_pressed() -> void:
	State.set_region(region)
	emit_signal("GameStart", NEW)
	queue_free()


func _on_ConvenienceStore_pressed(extra_arg_0: String) -> void:
	region = extra_arg_0
	$RegionDetail/TextureRect.visible = true
