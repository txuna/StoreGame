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

#  진열대 구매후 셋업
func setup():
	$CollisionShape2D.disabled = false 
	$DetectProduct/CollisionShape2D.disabled = false 
	$Wall/StaticBody2D/CollisionShape2D.disabled = false 
	$Wall/StaticBody2D2/CollisionShape2D.disabled = false
	add_items()
	_on_OptionButton_item_selected(0)


# 옵션 박스로 선택된 것과 일치하는 상품 코드인지 확인하여 증가 
func _on_DetectProduct_body_entered(body: Node) -> void:
	if body.is_in_group("products"):
		var id = body.get_id()
		if not basket.has(id):
			basket[id] = {
				"id" : id,
				"count" : 1
			}
			
		else:
			basket[id]["count"]+=1
		
		if current_product_id == id:
			State.change_displaystand_count(display_stand_number, 1, 1)
			#print(State.get_displaystand(display_stand_number))


func _on_DetectProduct_body_exited(body: Node) -> void:
	if body.is_in_group("products"):
		var id = body.get_id()
		if basket.has(id):
			if basket[id]["count"] - 1 <= 0:
				basket.erase(id)

			else:
				basket[id]["count"]-=1

		if current_product_id == id:
			State.change_displaystand_count(display_stand_number, 1, -1)
			#print(State.get_displaystand(display_stand_number))
			

func get_product_count(id):
	if basket.has(id):
		return basket[id]["count"]
	else:
		return 0

# 값이 변경된다면 현재 영역에 들어가 있는 아이템과 변경된 값과 일치된것이 무엇인지 알아야 함
func _on_OptionButton_item_selected(index: int) -> void:
	current_product_id = $OptionButton.get_item_id(index)
	State.set_displaystand(display_stand_number, current_product_id, true, get_product_count(current_product_id))
	#print(State.get_displaystand(display_stand_number))
