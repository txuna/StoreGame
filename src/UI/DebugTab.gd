extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_display():
	visible = true
	var products = State.get_product_all_index()
	for index in products:
		var product = products[index]
		var label = UIKit.make_label(str(product), 32)
		$TextureRect/VBoxContainer.add_child(label)


func _on_TextureButton_pressed() -> void:
	visible = false
