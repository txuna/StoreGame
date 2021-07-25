extends KinematicBody2D

# Called when the node enters the scene tree for the first time.

const Age1 = 0
const Age2 = 1
const Age3 = 2
const Age4 = 3 

var age_value = {
	Age1 : "0 ~ 19",
	Age2 : "20 ~ 39",
	Age3 : "40 ~ 59",
	Age4 : "60 ~ 79"
}

const Male = 1
const Female = 2

var gender_value = {
	Male : "Male",
	Female : "Female"
}

var npc_texture_list = [
	load("res://assets/art/npc/npc1.png"),
	load("res://assets/art/npc/npc2.png"),
	load("res://assets/art/npc/npc3.png"),
]

var velocity = Vector2.ZERO

const LEFT = -1
const RIGHT = 1
const IDLE = 0

var direction = RIGHT 
var npc_info 

signal NpcBuyProduct

const FailMsg = [
	"Where is the {name}?",
	"Damn It!!!! There is No {name}",
	"Reinvent the wheel.. {name}",
	"I'm starving to death. Where's {name}"
]

const SuccessMsg = [
	"Good Choice!!",
	"Get a Great Deals!!",
	"It's a no regret choice"
]

func _ready() -> void:
	$MoveTimer.wait_time = int(rand_range(2, 10))
	$BuyTimer.wait_time = int(rand_range(3, 10))
	$BuyTimer.one_shot = true
	$BuyTimer.start()


func _physics_process(delta: float) -> void:
	velocity.x = 45 * direction
	velocity.y += 75
	velocity = move_and_slide(velocity, Vector2.UP)


func get_random_texture():
	randomize()
	var temp = [0, 1, 2]
	return temp[randi() % temp.size()]
	
# NPC를 우클릭하면 상세탭이 나오고 물건 구매나, 돈이 부족할 때, 원하는 상품이 없을 떄 메시지를 띄운다.

# Info  suggestion이 0인거은 돈 부족으로 인한 구매 불가
# suggestion, age, gender, cash 
func setup(info:Dictionary):
	$Sprite.texture = npc_texture_list[get_random_texture()]
	npc_info = info
	set_detail()


func set_detail():
	$Detail/NameValue.text = npc_info["name"]
	$Detail/CashValue.text = str(npc_info["cash"]) + "$"
	$Detail/AgeValue.text = age_value[npc_info["age"]] + "olds"
	$Detail/GenderValue.text = gender_value[npc_info["gender"]] 


func _on_MoveTimer_timeout() -> void:
	randomize()
	var temp = [LEFT, RIGHT, IDLE]
	direction = temp[randi() % temp.size()]
	if direction == LEFT:
		$Sprite.flip_h = true 
	else:
		$Sprite.flip_h = false
	$MoveTimer.wait_time = int(rand_range(1, 4))

"""
Npc는 구매할 때 Storage노드 검사   
원하는 상품찾을때 ( productid와 in_display 체크 
그리고 산다면 해당상품이 어느 진열대인지 display_number 확인후 값조정
"""


# 구매 물품체크는 Map의 진열대 체크
# 구매 물품이 있다면 Good,  없다면 Ummm... 돈이 없다면 No Money :(  그리고 rating 평가
func _on_BuyTimer_timeout() -> void:
	buy_product()

	
	
# 확률적으로 msg float
"""
1. suggestion 체크 0x0이냐 아니냐 확인
2. Map/InStore product 체크
3. 만약 존재한다면 구매 시그널을 Game에 보낸다. 
"""

func buy_product():
	# 돈 부족
	var msg:String
	if npc_info["suggestion"] == 0x0:
		if get_probability(30):
			float_msg_buy("Lack of Money! XD")
		return 
		
	var product = get_node("/root/Main/Game/Map").get_product_in_store(npc_info["suggestion"], true)
	# 진열중인 상품이 존재하지 않을 떄 및 원하는 상품이 진열중이지 않을 때
	if product == null:
		if get_probability(30):
			var product_id = npc_info["suggestion"]
			float_msg_buy(FailMsg[randi() % FailMsg.size()].format({"name" : Products.get_products()[product_id]["name"]}))
		return 
	
	
	# 유통기한을 지났다면
	if not product.get_product_state():
		float_msg_buy("The expiration date has passed...!")
	# Game씬에서 해당 물건이 정확히 있는지 재점검 해야한다. 
	emit_signal("NpcBuyProduct", product)


	if get_probability(30):
		float_msg_buy(SuccessMsg[randi() % SuccessMsg.size()])



func get_probability(percent)->bool:
	var value = int(rand_range(0, 100))
	if percent <= value:
		return true 
	else:
		return false


func float_msg_buy(msg):
	$Chatbox.visible = true
	$Chatbox/Label.text = msg
	$Tween.interpolate_property($Chatbox, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$ChatTimer.start()
	yield($Tween, "tween_all_completed")
	
	

func _on_ExitChat_pressed() -> void:
	$Tween.interpolate_property($Chatbox, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Chatbox.visible = false


func _on_ChatTimer_timeout() -> void:
	$Tween.interpolate_property($Chatbox, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Chatbox.visible = false


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			$Detail.visible = true
			$Tween.interpolate_property($Detail, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			yield($Tween, "tween_all_completed")


func _on_DetailExit_pressed() -> void:
	$Tween.interpolate_property($Detail, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Detail.visible = false
