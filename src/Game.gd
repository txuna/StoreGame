extends Node2D

const STATE = 0
const SALES = 1
const STOCK = 2 
const EVENT = 3

const MAX_COUNT = 255 # 상품이 존재하는 갯수

var map = preload("res://src/Map/Map.tscn") 
var NpcManager = preload("res://src/Npcs/NpManager.tscn")
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
	connect("LoadPosUI", posui, "tab_switch")
	#connect("LoadPosUI", posui, "show_display")
	
	State.setup()
	NewsList.setup()
	var timer = Timer.new() 
	timer.wait_time = 5
	timer.one_shot = false
	timer.autostart = true 
	timer.connect("timeout", self, "save_data")
	add_child(timer)
	
	load_npc_manager()

func load_npc_manager():
	var npc_manager = NpcManager.instance()
	add_child(npc_manager)
	npc_manager.start_manager()
	
	
func save_data():
	SaveData.save_data()
	

func load_map():
	var map_instance = map.instance()
	map_instance.name = "Map"
	add_child(map_instance)
	

func _on_buy_product(product:Dictionary):
	if product.empty():
		emit_signal("ShowMsgBox", "Something is Wrong!")
		return 
		
	var cash = State.get_current_cash()
	if  cash < product["price"]:
		emit_signal("ShowMsgBox", "Lack of Money!")
		return 	
		
	if State.get_total_stock_count() >= MAX_COUNT:
		emit_signal("ShowMsgBox", "No space left on storage.")
		return 
	
	State.set_current_cash(product["price"], -1)
	
	# 개별상품 관리를 위한 인덱스 부여
	var shelf_life = Products.get_products()[product["id"]]["shelf_life"]
	var index = State.find_free_index()                        # 1800
	State.set_product_index(index, product["id"], shelf_life * 1200) #index와 count의 차이 : index는 개별상품에 대한 관리이고 count는 id가 같은 상품끼리 통틀어서 관리함 
	
	State.set_product_count(product["id"], product["count"], 1)
	
	for i in product["count"]:
		get_node("Map").load_product(index, product["id"])
		
	get_node("Map").show_cash()
	emit_signal("LoadPosUI", STOCK)
	

func _on_buy_display_stand(index:int):
	if index <= 0 or index >= 11:
		emit_signal("ShowMsgBox", "Something is wrong!")
		return 
		
	var cash = State.get_current_cash()
	var price = State.get_display_stand_price() 
	if cash < price:
		emit_signal("ShowMsgBox", "Lack of Money!")
		return 
		
	State.set_current_cash(price, -1)
	State.set_display_stand_price(2)
	get_node("Map").show_display_stand(index)
	get_node("Map").show_cash()

func _on_error():
	pass
