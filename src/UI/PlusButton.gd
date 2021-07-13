extends Control


signal BuyDisplayStand

var display_stand_number

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_display_stand_number(index):
	display_stand_number = index


func _on_TextureButton_pressed() -> void:
	emit_signal("BuyDisplayStand", display_stand_number)
