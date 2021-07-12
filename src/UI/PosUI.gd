extends Control


const STATE = 0
const SALES = 1
const STOCK = 2 

onready var StateTab = $PosContainer/PosBack/State
onready var SalesTab = $PosContainer/PosBack/Sales
onready var StockTab = $PosContainer/PosBack/Stock

onready var Stock_NameContainer = $PosContainer/PosBack/Stock/NameContainer/vbox
onready var Stock_SalesContainer = $PosContainer/PosBack/Stock/BuyContainer/vbox
onready var Stock_StockContainer = $PosContainer/PosBack/Stock/StockContainer/vbox



var current_tab = STATE
var tab_list = []

var ui_kit
var products

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
		}
	]
	ui_kit = UIkit.new()
	products = Products.new()
	tab_switch(current_tab)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#################################################################
	
func init_stock():
	for child in Stock_NameContainer.get_children():
		child.queue_free()
		
	for child in Stock_SalesContainer.get_children():
		child.queue_free()
		
	for child in Stock_StockContainer.get_children():
		child.queue_free()

func load_stock():
	init_stock()
	var product_list = products.get_products()
	for id in product_list:
		var product = product_list[id]
		make_product_name(product["name"])
		make_buy(product)

	
func make_product_name(text:String):
	var label = ui_kit.make_label(text, 24)
	Stock_NameContainer.add_child(label)
	
	
func make_buy(product):
	# normal pressed, hover, disable
	var hbox = ui_kit.make_hbox()
	hbox.name = str(product["id"])
	var plus_btn = ui_kit.make_texture_btn(
		"res://assets/art/ui/plus.png",
		"res://assets/art/ui/plus_pressed.png",
		"res://assets/art/ui/plus_pressed.png")
	
	var count = ui_kit.make_label("1", 36)
	count.name = "count"

	var minus_btn = ui_kit.make_texture_btn(
		"res://assets/art/ui/minus.png",
		"res://assets/art/ui/minus_pressed.png",
		"res://assets/art/ui/minus_pressed.png")
	
	var price = ui_kit.make_label(str(product["buy"])+"$", 36)	
	price.name = "price"
		
	var buy_btn = ui_kit.make_texture_btn(
		"res://assets/art/ui/buy_btn.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png")
		
	plus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], product["buy"], 1])	
	minus_btn.connect("pressed", self, "_on_count_btn_pressed", [product["id"], product["buy"], -1])	
	
	hbox.add_child(plus_btn)
	hbox.add_child(count)
	hbox.add_child(minus_btn)
	hbox.add_child(price)
	hbox.add_child(buy_btn)
	Stock_SalesContainer.add_child(hbox)
	
func make_stock():
	pass

func _on_count_btn_pressed(id, price, mask):
	var hbox = Stock_SalesContainer.get_node(str(id))
	var value = int(hbox.get_node("count").text)
	value += (1*mask)
	if value < 0 or value > 10:
		return
	hbox.get_node("count").text = str(value)
	hbox.get_node("price").text = str(value * price) + "$"
#################################################################

func _on_TextureButton_pressed() -> void:
	ui_kit.free()
	products.free()
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

