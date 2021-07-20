extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_display(id):
	visible = true
	var product = Products.get_products()[id]
	$TextureRect/ProductNameValue.text = product["name"]
	$TextureRect/BuyValue.text = str(product["buy"])+"$"
	$TextureRect/SellValue.text = str(product["sell"] )+ "$"
	$TextureRect/ShelfLifeValue.text = str(product["shelf_life"]) + " days"
	$TextureRect/MoistureValue.text = str(product["moisture"] * 10) + "%"
	$TextureRect/SatietyValue.text = str(product["satiety"] * 10 )+ "%"
	$TextureRect/HealthValue.text = str(product["health"]) + "/10 points"
	$TextureRect/TypeValue.text = Products.get_temperature_str(product["temperature"]) 
	$TextureRect/TasteValue.text = str(product["taste"]) + "/10 points"


func _on_TextureButton_pressed() -> void:
	visible = false
