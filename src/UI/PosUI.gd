extends Control


onready var StateTab = $PosContainer/PosBack/State
onready var SalesTab = $PosContainer/PosBack/Sales
onready var StockTab = $PosContainer/PosBack/Stock
onready var EventTab = $PosContainer/PosBack/Event

onready var Stock_NameContainer = $PosContainer/PosBack/Stock/NameContainer/vbox
onready var Stock_SalesContainer = $PosContainer/PosBack/Stock/BuyContainer/vbox
onready var Stock_StockContainer = $PosContainer/PosBack/Stock/StockContainer/vbox

onready var Midnight = $PosContainer/PosBack/Sales/Time/midnightValue
onready var Morning = $PosContainer/PosBack/Sales/Time/morningValue
onready var Afternoon = $PosContainer/PosBack/Sales/Time/afternoonValue
onready var Evening = $PosContainer/PosBack/Sales/Time/eveningValue

onready var Age1 = $PosContainer/PosBack/Sales/Age/age1Value
onready var Age2 = $PosContainer/PosBack/Sales/Age/age2Value
onready var Age3 = $PosContainer/PosBack/Sales/Age/age3Value
onready var Age4 = $PosContainer/PosBack/Sales/Age/age4Value

onready var Male = $PosContainer/PosBack/Sales/Gender/maleValue
onready var Female = $PosContainer/PosBack/Sales/Gender/femaleValue

signal ChangeStatus

signal BuyProduct
signal ShowDetail

var current_tab = Global.STATE
var tab_list = []

var buy_list = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var product_detail = get_node("../ProductDetail")
	connect("ShowDetail", product_detail, "show_display")
	
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
	#tab_switch(current_tab)

func show_display(tab_index=0):
	visible = true 
	if tab_index == Global.STATE:
		load_state()
	
	elif tab_index == Global.SALES:
		load_sales()
		
	elif tab_index == Global.STOCK:
		load_stock()
		
	elif tab_index == Global.EVENT:
		load_event()
		
#############################SALES####################################
func init_sales():
	for child in $PosContainer/PosBack/Sales/IncomeContainer/VBoxContainer.get_children():
		child.queue_free()
		
	for child in $PosContainer/PosBack/Sales/ExpandContainer/VBoxContainer.get_child_count():
		child.queue_free()
		
		

func load_sales():
	init_sales()
	show_income()
	show_TimeAge_statistics()


func show_income():
	var income_dict = {}
	var type:String
	var iname:String
	var logfile = State.get_income_log() 
	for income in logfile:
		var metadata = income["metadata"]
		if income["type"] == Global.Product:
			type = "[Product]"
			iname = Products.get_products()[metadata["id"]]["name"]
		else:
			type = "[Tip]"
			iname = "Tip"
			
		if not income_dict.has(metadata["id"]):
			income_dict[metadata["id"]] = {
				"count" : metadata["count"],
				"price" : income["price"],
				"type" : type,
				"name" : iname
			}
		else:
			income_dict[metadata["id"]]["count"] += metadata["count"]
			income_dict[metadata["id"]]["price"] += income["price"]
			
	for income in income_dict:
		var label = UIKit.make_label("{type} {name} x {count} = ${price}".format({
			"type" : income_dict[income]["type"],
			"name" : income_dict[income]["name"],
			"count" : income_dict[income]["count"],
			"price" : income_dict[income]["price"],
		}), 24)
	
		$PosContainer/PosBack/Sales/IncomeContainer/VBoxContainer.add_child(label)
	
		
func show_expanditure():
	var expanditure_dict = {}	
		
		
func show_TimeAge_statistics():
	var logfile = State.get_income_log() 
	var length = 0
	var time_dict = {
		Global.Midnight : {
			"node" : Midnight,
			"value" : 0.0,
		},
		Global.Morning : {
			"node" : Morning,
			"value" : 0.0 
		},
		Global.Afternoon : {
			"node" : Afternoon,
			"value" : 0.0,
		},
		Global.Evening : {
			"node" : Evening,
			"value" : 0.0
		},
	}
	var age_dict = {
		Global.Age1 : {
			"node" : Age1,
			"value" : 0.0
		}, 
		Global.Age2 : {
			"node" : Age2,
			"value" : 0.0
		}, 
		Global.Age3 : {
			"node" : Age3,
			"value" : 0.0
		},
		Global.Age4 : {
			"node" : Age4,
			"value" : 0.0
		},
	}
	var gender_dict = {
		Global.Male : {
			"node" : Male,
			"value" : 0.0
		},
		Global.Female : {
			"node" : Female,
			"value" : 0.0
		}
	}
	
	for income in logfile:
		if income["type"] != Global.Product:
			continue
	
		var metadata = income["metadata"]
		var age = metadata["age"]
		var time = metadata["time"]
		var gender = metadata["gender"]
		time_dict[time]["value"]+=1.0
		age_dict[age]["value"]+=1.0
		gender_dict[gender]["value"]+=1.0
		length+=1

	for time in time_dict:
		var value = time_dict[time]["value"]
		var node = time_dict[time]["node"]
		var lstr:String
		if length == 0:
			lstr= "0%"
		else:
			lstr = str(stepify(value/length*100, 0.1))+"%"
		node.text = lstr
		
	for age in age_dict:
		var value = age_dict[age]["value"]
		var node = age_dict[age]["node"]
		var lstr:String
		if length == 0:
			lstr= "0%"
		else:
			lstr = str(stepify(value/length*100, 0.1))+"%"
		node.text = lstr
		
	for gender in gender_dict:
		var value = gender_dict[gender]["value"]
		var node = gender_dict[gender]["node"]
		var lstr:String
		if length == 0:
			lstr= "0%"
		else:
			var tmp = stepify(value/length*100, 0.1)
			lstr = str(tmp)+"%"
			if gender == Global.Male:
				$PosContainer/PosBack/Sales/Gender/TextureProgress.value = tmp
		node.text = lstr

############################EVENT#####################################		
func load_event():
	pass


############################STATE#####################################

func load_state():
	StateTab.get_node("StoreNameValue").text = State.get_name()
	StateTab.get_node("DateValue").text = "{day}:{hour}:{min}:{sec}".format(
		{
			"day" : State.get_day()["str"],
			"hour" : State.get_time()["hour"],
			"min" : State.get_time()["min"],
			"sec" : State.get_time()["sec"]})

	StateTab.get_node("CashValue").text = "$" + str(State.get_current_cash())
	StateTab.get_node("ExpenditureValue").text = "$" +str(State.get_expenditure())
	StateTab.get_node("IncomeValue").text = "$" +str(State.get_income())
	StateTab.get_node("RatingValue").text = str(State.get_rating()) + " / 5"
	var pos = State.get_pos()
	StateTab.get_node("PositionValue").text = pos +" Region"
	load_is_open()
	
	
	
func load_is_open():
	var value = State.is_open()
	## OPEN 
	if value:
		set_statusBtn("res://assets/art/state/open.png", "res://assets/art/state/open_pressed.png")
		
	else:
		set_statusBtn("res://assets/art/state/close.png", "res://assets/art/state/close_pressed.png")
	

func set_statusBtn(image:String, image_pressed:String):
	$PosContainer/PosBack/State/StatusBtn.texture_normal = load(image)
	$PosContainer/PosBack/State/StatusBtn.texture_hover = load(image_pressed)
	$PosContainer/PosBack/State/StatusBtn.texture_pressed = load(image_pressed)
	$PosContainer/PosBack/State/StatusBtn.texture_disabled = load(image_pressed)


func active_status_btn():
	$PosContainer/PosBack/State/StatusBtn.disabled = false 
	$PosContainer/PosBack/State/StatusLabel.visible = false


func _on_StatusBtn_pressed() -> void:
	var value = State.is_open()
	if not value == Global.CLOSE:
		$PosContainer/PosBack/State/StatusBtn.disabled = true
		$PosContainer/PosBack/State/StatusLabel.visible = true
	else:
		$PosContainer/PosBack/State/StatusLabel.visible = false
		
	emit_signal("ChangeStatus", not value)
	#load_state()

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
	$PosContainer/PosBack/Stock/MoneyValue.text ="$"+str(State.get_current_cash())
	var product_list = Products.get_products()
	for id in product_list:
		var product = product_list[id]
		make_product_name(product["name"], product["id"])
		make_buy(product)
		make_stock(product["id"])
		
	
func make_product_name(text:String, id:int):
	var label = UIKit.make_label(text, 24)
	Stock_NameContainer.add_child(label)
	label.set_mouse_filter(1)
	label.connect("gui_input", self, "_on_show_product_detail", [id])
	
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
	
	var price = UIKit.make_label("$"+str(product["buy"]), 36)	
		
	var buy_btn = UIKit.make_texture_btn(
		"res://assets/art/ui/buy_btn.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png",
		"res://assets/art/ui/buy_btn_pressed.png")
		
	# ?????????????????? ??????
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
	price.text = "$"+str(value * buy)
	
	buy_list[id]["count"] = value 
	buy_list[id]["price"] = value * buy
	
	
func _on_pressed_buy_btn(id):
	emit_signal("BuyProduct", buy_list[id])
	
	
func _on_show_product_detail(event, id):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("ShowDetail", id)
	


func _on_NameContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and current_tab == Global.STOCK:
		if event.button_index == BUTTON_WHEEL_UP:
			$PosContainer/PosBack/Stock/BuyContainer.scroll_vertical -= 30
			$PosContainer/PosBack/Stock/StockContainer.scroll_vertical -= 15
		
		if event.button_index == BUTTON_WHEEL_DOWN:
			$PosContainer/PosBack/Stock/BuyContainer.scroll_vertical += 30
			$PosContainer/PosBack/Stock/StockContainer.scroll_vertical += 15


func _on_BuyContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and current_tab == Global.STOCK:
		if event.button_index == BUTTON_WHEEL_UP:
			$PosContainer/PosBack/Stock/StockContainer.scroll_vertical -= 15 
			$PosContainer/PosBack/Stock/NameContainer.scroll_vertical -= 15

		if event.button_index == BUTTON_WHEEL_DOWN:
			$PosContainer/PosBack/Stock/StockContainer.scroll_vertical += 15 
			$PosContainer/PosBack/Stock/NameContainer.scroll_vertical += 15
			

func _on_StockContainer_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and current_tab == Global.STOCK:
		if event.button_index == BUTTON_WHEEL_UP:
			$PosContainer/PosBack/Stock/BuyContainer.scroll_vertical -= 30
			$PosContainer/PosBack/Stock/NameContainer.scroll_vertical -= 15
		
		if event.button_index == BUTTON_WHEEL_DOWN:
			$PosContainer/PosBack/Stock/BuyContainer.scroll_vertical += 30
			$PosContainer/PosBack/Stock/NameContainer.scroll_vertical += 15
	
#################################################################

func _on_TextureButton_pressed() -> void:
	visible = false

func _on_StateBtn_pressed() -> void:
	tab_switch(Global.STATE)


func _on_SalesBtn_pressed() -> void:
	tab_switch(Global.SALES)


func _on_StockBtn_pressed() -> void:
	tab_switch(Global.STOCK)
	load_stock()


func tab_switch(index):
	if index == Global.RELOAD and visible == true:
		show_display(current_tab)
		return 
		
	current_tab = index
	var count = 0
	for i in tab_list:
		if count == index:
			i["Btn"].pressed = true 
			i["Tab"].visible = true
			show_display(current_tab)
		else:
			i["Btn"].pressed = false 
			i["Tab"].visible = false 
		count+=1
	


func _on_EventBtn_pressed() -> void:
	tab_switch(Global.EVENT)

