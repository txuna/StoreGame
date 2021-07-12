extends Node2D

const STATE = 0
const SALES = 1
const STOCK = 2 

var map = preload("res://src/Map/Map.tscn") 
var msgbox = null
signal LoadPosUI

var PosTabIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func start_game():
	setup()
	load_map()
	
	
func setup():
	msgbox = get_node("../UiLayer/MsgBox")
	var posui = get_node("../UiLayer/PosUI")
	posui.connect("BuyProduct", self, "_on_buy_product")
	connect("LoadPosUI", posui, "show_display")
	

func load_map():
	var map_instance = map.instance()
	map_instance.name = "Map"
	add_child(map_instance)
	

func _on_buy_product(product:Dictionary):
	var cash = State.get_current_cash()
	if cash < product["price"]:
		msgbox.show_display("lack of cash!")
		return 	
	
	State.set_current_cash(product["price"], -1)
	State.set_product_count(product["id"], product["count"], 1)
	get_node("Map").load_product(product["id"], product["count"])
	emit_signal("LoadPosUI", STOCK)


func _on_error():
	pass
