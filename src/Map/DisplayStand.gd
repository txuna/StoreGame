extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

var display_stand_number = 1
var current_product_id = 0x0


# 진열된 상품 == 해당 영역에 들어간 상품의 종류들
var basket = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape2D.disabled = true
	$DetectProduct/CollisionShape2D.disabled = true
	$Wall/StaticBody2D/CollisionShape2D.disabled = true
	$Wall/StaticBody2D2/CollisionShape2D.disabled = true
	#add_items()
	#current_product_id = $OptionButton.get_item_id(0)
	#_on_OptionButton_item_selected(0)
	

func set_display_stand_number(index):
	display_stand_number = index

func get_display_stand_number():
	return display_stand_number

func add_items():
	var products = Products.get_products()
	for id in products:
		var product = products[id]
		$OptionButton.add_item(product["name"], product["id"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#  진열대 구매후 셋업 기본값으로 콜라로 설정되어 있다.
func setup(productId=0xA000):
	$CollisionShape2D.disabled = false 
	$DetectProduct/CollisionShape2D.disabled = false 
	$Wall/StaticBody2D/CollisionShape2D.disabled = false 
	$Wall/StaticBody2D2/CollisionShape2D.disabled = false
	add_items()
	var index = $OptionButton.get_item_index(productId) 
	$OptionButton.select(index)
	_on_OptionButton_item_selected(index)

func get_product_position():
	return $CreateProduct.global_position

# 옵션 박스로 선택된 것과 일치하는 상품 코드인지 확인하여 증가 
func _on_DetectProduct_body_entered(body: Node) -> void:
	if body.is_in_group("products"):
		body.set_display_number(display_stand_number)
		var id = body.get_id()
		if not basket.has(id):
			basket[id] = {
				"id" : id,
				"count" : 1,
				#"shelf_life_list" : [] #저장할 때 Storage검사해서 그떄 넣자
			}	
		else:
			basket[id]["count"]+=1
		
		if current_product_id == id:
			body.set_is_correct_display(true)
			$Count.text = str(basket[id]["count"]) +"pcs"
			State.change_displaystand_count(display_stand_number, 1, 1)


func _on_DetectProduct_body_exited(body: Node) -> void:
	if body.is_in_group("products"):
		body.set_display_number(0x0)
		var id = body.get_id()
		if basket.has(id):
			basket[id]["count"] -= 1
		else:
			basket[id] = {
				"id" : id,
				"count" : 0
			}
		
		if current_product_id == id:
			body.set_is_correct_display(false)
			$Count.text = str(basket[id]["count"]) +"pcs"
			State.change_displaystand_count(display_stand_number, 1, -1)


func get_product_count(id):
	if basket.has(id):
		return basket[id]["count"]
	else:
		return 0
		

# 값이 변경된다면 현재 영역에 들어가 있는 아이템과 변경된 값과 일치된것이 무엇인지 알아야 함
# 해당 진열대에 있는 상품과 옵션버튼과 동일해진다면
# 
func _on_OptionButton_item_selected(index: int) -> void:
	current_product_id = $OptionButton.get_item_id(index)
	if basket.has(current_product_id):
		$Count.text = str(basket[current_product_id]["count"]) +"pcs"
	else:
		$Count.text = "0pcs"
	State.set_displaystand(display_stand_number, current_product_id, true, get_product_count(current_product_id))
	# products index별로 set_is_correct_display() 세팅 
	var products = get_node("/root/Main/Game/Map/InStore/Storage").get_children()
	for product in products:
		if product.get_display_number() == display_stand_number:
			if product.get_id() == current_product_id:
				product.set_is_correct_display(true)
