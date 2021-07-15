extends Control


signal GameStart

const NEW = 0
const CONTINUE = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func _on_GameStart_pressed() -> void:
	emit_signal("GameStart", CONTINUE)


func _on_TextureButton2_pressed() -> void:
	emit_signal("GameStart", NEW)
