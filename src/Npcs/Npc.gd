extends KinematicBody2D

# Called when the node enters the scene tree for the first time.

var age_value = {
	Global.Age1 : "0 ~ 19",
	Global.Age2 : "20 ~ 39",
	Global.Age3 : "40 ~ 59",
	Global.Age4 : "60 ~ 79"
}


var gender_value = {
	Global.Male : "Male",
	Global.Female : "Female"
}

var npc_texture_list = [
	load("res://assets/art/npc/npc1.png"),
	load("res://assets/art/npc/npc2.png"),
	load("res://assets/art/npc/npc3.png"),
]

var velocity = Vector2.ZERO
var direction = Global.RIGHT 
var npc_info 

var flag

signal NpcBuyProduct
signal NpcExited


func _ready() -> void:
	flag = Global.Shopping
	$MoveTimer.wait_time = int(rand_range(2, 10))
	$BuyTimer.wait_time = int(rand_range(3, 10))
	$BuyTimer.one_shot = true
	$BuyTimer.start()


func _physics_process(delta: float) -> void:
	velocity.x = 75 * direction
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
	var temp = [Global.LEFT, Global.RIGHT, Global.IDLE]
	direction = temp[randi() % temp.size()]
	if direction == Global.LEFT:
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
			float_msg_buy(Global.FailMsg[randi() % Global.FailMsg.size()].format({"name" : Products.get_products()[product_id]["name"]}))
		return 
	
	
	# 유통기한을 지났다면
	if not product.get_product_state():
		float_msg_buy("The expiration date has passed...!")
		return 
		
	# Game씬에서 해당 물건이 정확히 있는지 재점검 해야한다. 
	emit_signal("NpcBuyProduct", product, npc_info["age"], npc_info["gender"])


	if get_probability(30):
		float_msg_buy(Global.SuccessMsg[randi() % Global.SuccessMsg.size()])

	flag = Global.EndShopping
	direction = Global.LEFT
	$Sprite.flip_h = true
	$BuyTimer.stop() 
	$MoveTimer.stop()
	

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
	
	
# Buy Timer and Move Timer 중단
# 문밖으로 퇴장한다. 나갈때 NpManager에서 시그널로 tree_exited가 되면 콜백함수 -> group 체크
# 터치다운? 특정 flag단 상태에서?
# 특정 경로를따라 걷게한다음 해당 지점에 도달하게 된다면 _on_npc_exited
func exit_store():
	flag = Global.KickNpc
	$BuyTimer.stop() 
	$MoveTimer.stop()
	
	if get_probability(30):
		float_msg_buy(Global.ExitMsg[randi() % Global.ExitMsg.size()])
			
	direction = Global.LEFT
	$Sprite.flip_h = true


# NPC가 Map의 특정 지점에 닿으면 signal 전송
func get_flag():
	return flag

# NPC가 나가는도중 게임을 중단하면? 
func _on_npc_exited():
	queue_free()










