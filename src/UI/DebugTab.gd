extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var current_tab = "product"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init():
	for child in $TextureRect/VBoxContainer.get_children():
		child.queue_free()

func show_display():
	init()
	visible = true
	
	if current_tab == "product":
		var products = State.get_product_all_index()
		for index in products:
			var product = products[index]
			var label = UIKit.make_label(str(product), 28)
			$TextureRect/VBoxContainer.add_child(label)

	elif current_tab == "display":
		var display_list = State.get_all_display_stand()
		for number in display_list:
			var display = display_list[number]
			var label = UIKit.make_label(str(display), 32)
			$TextureRect/VBoxContainer.add_child(label)


func _on_TextureButton_pressed() -> void:
	visible = false


func _on_Productdbg_pressed() -> void:
	current_tab = "product"
	show_display()


func _on_Displaydbg_pressed() -> void:
	current_tab = "display"
	show_display()
