extends Node2D

const STATE = 0
const SALES = 1
const STOCK = 2 
const EVENT = 3

var map = preload("res://src/Map/Map.tscn") 
#var msgbox = null
signal LoadPosUI
signal ShowMsgBox

var PosTabIndex = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func start_game():
	setup()
	load_map()
	
	
func setup():
	var msgbox = get_node("../UiLayer/MsgBox")
	connect("ShowMsgBox", msgbox, "show_display")
	
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
		emit_signal("ShowMsgBox", "Lack of Money!")
		#msgbox.show_display("Lack of Cash!")
		return 	
	
	State.set_current_cash(product["price"], -1)
	State.set_product_count(product["id"], product["count"], 1)
	get_node("Map").load_product(product["id"], product["count"])
	get_node("Map").show_cash()
	emit_signal("LoadPosUI", STOCK)
	

func _on_buy_display_stand(index:int):
	var cash = State.get_current_cash()
	var price = State.get_display_stand_price() 
	if cash < price:
		emit_signal("ShowMsgBox", "Lack of Money!")
		#msgbox.show_display("Lack of Cash!")
		return 
		
	State.set_current_cash(price, -1)
	State.set_display_stand_price(2)
	get_node("Map").show_display_stand(index)
	get_node("Map").show_cash()

func _on_error():
	pass
