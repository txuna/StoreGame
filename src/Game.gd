extends Node2D

var map = preload("res://src/Map/Map.tscn") 
var NpcManager = preload("res://src/Npcs/NpManager.tscn")
#var msgbox = null
signal LoadPosUI
signal ShowMsgBox
signal ActiveStatusBtn

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
	posui.connect("ChangeStatus", self, "_on_change_store_status") # 가게 문 닫고 열기
	connect("LoadPosUI", posui, "tab_switch")
	connect("ActiveStatusBtn", posui, "active_status_btn")

	State.setup()
	NewsList.setup()

	load_npc_manager()


func load_npc_manager():
	var npc_manager = NpcManager.instance()
	npc_manager.connect("AllNpcExited", self, "_on_all_npc_exited")
	npc_manager.name = "NpcManager"
	add_child(npc_manager)	
	if State.is_open():
		npc_manager.start_manager()
	

func load_map():
	var posui = get_node("../UiLayer/PosUI")
	var map_instance = map.instance()
	map_instance.name = "Map"
	map_instance.connect("LoadPosUI", posui, "tab_switch")
	add_child(map_instance)


func _on_change_store_status(status):
	State.set_status(status)
	emit_signal("LoadPosUI", Global.RELOAD)
	if status == Global.OPEN:
		get_node("NpcManager").start_manager()
		
	# 맵에 존재하는 모든 NPC들이 문박으로 나가 queue_free함 -> 할때마다 group 개체수 체크 -> 0이되면 그떄 버튼 disable = false 
	elif status == Global.CLOSE:
		get_node("NpcManager").stop_manager()
		var nodes = get_tree().get_nodes_in_group("Npcs")
		# 맵에 존재하는 모든 NPC에게 signal connect
		
		# 만약 이미 없는 상태라면
		if  get_tree().get_nodes_in_group("Npcs").size() == 0:
			_on_all_npc_exited()
			return 
			
		# NPC가 맵에 존재하는 상태라면
		for node in nodes:
			node.connect("tree_exited", self, "_on_all_npc_exited")
			
		get_tree().call_group("Npcs", "exit_store")


func _on_all_npc_exited():
	if get_tree().get_nodes_in_group("Npcs").size() == 0:
		print("All npc exited!")
		emit_signal("ActiveStatusBtn")


# Stock 탭 정리 
# products 탭 정리 
# DisplayStand는 정리안해도 object가 queue_free하는 과정에서 자동으로 될듯 바로 free하면 DisplayStand.gd에서 exit 에러 뜰듯한데
# 위에 다 체크 및 정리하고 나서 Cash 정리
# 정산 및 레이팅
func _on_npc_buy_product(product):
	var id = product.get_id() 
	var index = product.get_product_index()
	var dispay_number = product.get_display_number()
	var flag = true
	
	if State.get_total_product_count(id) > 0:
		State.set_product_count(id, 1, -1)
	else:
		if OS.is_debug_build():
			print("get_total_product_count() {id}".format({"id" : id}))
		flag = false
		
	if State.has_product_in_products(index):
		State.remove_product_index(index)
	else:
		if OS.is_debug_build():
			print("has_product_in_products() {index}".format({"index" : index}))
		flag = false 
		
	if not flag:
		if OS.is_debug_build():
			print("ERROR in _on_npc_buy_products")
		return #ERROR 
		
	
	if OS.is_debug_build():
		print("Sell index {index}".format({"index" : index}))	
		
	
	var price = Products.get_products()[id]["sell"]
	# 유통기한이 지났다면
	if not product.get_product_state():
		if OS.is_debug_build():
			print("The expiration date has passed {index} and {id}".format({"index" : index, "id" : id}))
		price = 0
	State.set_current_cash(price ,1)

	get_node("Map").show_cash()
	
	product.queue_free()
	
	emit_signal("LoadPosUI", Global.RELOAD)



func _on_buy_product(product:Dictionary):
	if product.empty():
		emit_signal("ShowMsgBox", "Something is Wrong!")
		return 
		
	var cash = State.get_current_cash()
	if  cash < product["price"]:
		emit_signal("ShowMsgBox", "Lack of Money!")
		return 	
		
	if State.get_total_stock_count() + product["count"] >= Global.MAX_COUNT:
		emit_signal("ShowMsgBox", "No space left on storage. Left {number} space".format({"space" : Global.MAX_COUNT - State.get_total_stock_count()}))
		return 
	
	State.set_current_cash(product["price"], -1)
	State.set_product_count(product["id"], product["count"], 1)
	
	# 개별상품 관리를 위한 인덱스 부여
	var flag = false
	for i in range(product["count"]):
		var shelf_life = Products.get_products()[product["id"]]["shelf_life"]
		var index = State.find_free_index()                        # 1800
		if index == -1:
			if OS.is_debug_build():
				print("in _on_buy_product() get index -1, failed load product")
			if not flag:
				flag = true 
				continue
			else:
				 break
		State.set_product_index(index, product["id"], shelf_life * 1200) #index와 count의 차이 : index는 개별상품에 대한 관리이고 count는 id가 같은 상품끼리 통틀어서 관리함 
		get_node("Map").load_product(index, product["id"])
		
	get_node("Map").show_cash()
	emit_signal("LoadPosUI", Global.STOCK)
	
	#Save!
	#SaveData.save_data()


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
	
	#Save!
	#SaveData.save_data()
	

func _on_error():
	pass
