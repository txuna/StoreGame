extends Control


const STATE = 0
const SALES = 1
const STOCK = 2
const EVENT = 3 

onready var StateTab = $PosContainer/PosBack/State
onready var SalesTab = $PosContainer/PosBack/Sales
onready var StockTab = $PosContainer/PosBack/Stock
onready var EventTab = $PosContainer/PosBack/Event

onready var Stock_NameContainer = $PosContainer/PosBack/Stock/NameContainer/vbox
onready var Stock_SalesContainer = $PosContainer/PosBack/Stock/BuyContainer/vbox
onready var Stock_StockContainer = $PosContainer/PosBack/Stock/StockContainer/vbox

signal BuyProduct


var current_tab = STATE
var tab_list = []

var buy_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tabs = $PosContainer/PosBack
	for tab in tabs.get_children():
		tab.visible = false
	tab_list = [
		{
			"Btn" : $PosContainer/Tabs/StateBtn,
			"Tab" : StateTab
		},
		{
			"Btn" : $PosContainer/Tabs/SalesBtn,
			"Tab" : SalesTab
		},
		{
			"Btn" : $PosContainer/Tabs/StockBtn,
			"Tab" : StockTab
		},
		{
			"Btn" : $PosContainer/Tabs/EventBtn,
			"Tab" : EventTab
			
		}
	]
	tab_switch(current_tab)

func show_display(tab_index=0):
	visible = true 
	if tab_index == STATE:
		pass
	
	elif tab_index == SALES:
		pass
		
	elif tab_index == STOCK:
		load_stock()

############################STOCK#####################################
	
func init_stock():
	for child in Stock_NameContainer.get_children():
		child.queue_free()
		
	for child in Stock_SalesContainer.get_children():
		child.queue_free()
		
	for child in Stock_StockContainer.get_children():
		child.queue_free()

func load_stock():
	init_stock()
	$PosContainer/PosBack/Stock/MoneyValue.text = str(State.get_current_cash()) + "$"
	var product_list = Products.get_products()
	for id in product_list:
		var product = product_list[id]
		make_product_name(product["name"])
		make_buy(product)
		make_stock(product["id"])
		
	
func make_product_name(text:String):
	var label = UIKit.make_label(text, 24)
	Stock_NameContainer.add_child(label)
	
	
func make_buy(product):
	# normal pressed, hover, disable
	var hbox = UIKit.make_hbox()
	var plus_btn = UIKit.make_texture_btn(
		"res://assets/art/ui/plus.png",
		"res://assets/art/ui/plus_pressed.png",
		"res://assets/art/ui/plus_pressed.png")
	
	var count = UIKit.make_label("1", 36)

	var minus_btn = UIKit.make_texture_btn(
		"res://assets/art/ui/minus.png",
		"res://assets/art/ui/minus_pressed.png",
		"res://assets/art/ui/minus_pressed.png")
	
	var price = UIKit.make_label(str(product["buy"])+"$", 36)	
		
	var buy_btn = UIKit.make_texture_btn(
		"res://assets/art/ui/buy_btn.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png")
		
	# 쇼핑리스트에 추가
	buy_list[product["id"]] = {
		"id" : product["id"],
		"count" : 1,
		"price" : product["buy"],
	}
		
	#plus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], product["buy"], 1])	
	#minus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], product["buy"], -1])	
	plus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], count, price, product["buy"], 1])	
	minus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], count, price, product["buy"], -1])	
	buy_btn.connect("pressed", self, "_on_pressed_buy_btn", [product["id"]])
	
	hbox.add_child(plus_btn)
	hbox.add_child(count)
	hbox.add_child(minus_btn)
	hbox.add_child(price)
	hbox.add_child(buy_btn)
	Stock_SalesContainer.add_child(hbox)
	
func make_stock(id):
	var count = State.get_total_product_count(id)
	var count_label = UIKit.make_label(str(count)+" pcs", 24)
	Stock_StockContainer.add_child(count_label) 


func _on_count_btn_pressed(id, count:Label, price:Label, buy:int, mask):
	var value = int(count.text)
	value += (1*mask)
	if value < 0 or value > 10:
		return
	count.text = str(value)
	price.text = str(value * buy) + "$"
	
	buy_list[id]["count"] = value 
	buy_list[id]["price"] = value * buy
	
	
func _on_pressed_buy_btn(id):
	emit_signal("BuyProduct", buy_list[id])
	
	
#################################################################

func _on_TextureButton_pressed() -> void:
	visible = false

func _on_StateBtn_pressed() -> void:
	tab_switch(STATE)


func _on_SalesBtn_pressed() -> void:
	tab_switch(SALES)


func _on_StockBtn_pressed() -> void:
	tab_switch(STOCK)
	load_stock()


func tab_switch(index):
	current_tab = index
	var count = 0
	for i in tab_list:
		if count == index:
			i["Btn"].pressed = true 
			i["Tab"].visible = true
		else:
			i["Btn"].pressed = false 
			i["Tab"].visible = false 
		count+=1



func _on_EventBtn_pressed() -> void:
	tab_switch(EVENT)
