extends KinematicBody2D

# Called when the node enters the scene tree for the first time.

const Age1 = 0
const Age2 = 1
const Age3 = 2
const Age4 = 3 

var age_value = {
	Age1 : [0, 19],
	Age2 : [20, 39],
	Age3 : [40, 59],
	Age4 : [60, 79]
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

func _ready() -> void:
	position = get_parent().get_spawn_npc_position()
	$BuyTimer.wait_time = int(rand_range(3, 10))
	$BuyTimer.one_shot = true
	$BuyTimer.start()


func _physics_process(delta: float) -> void:
	velocity.x += 30 * direction * delta
	velocity.y += 50 * delta
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



func _on_MoveTimer_timeout() -> void:
	randomize()
	var temp = [LEFT, RIGHT, IDLE]
	direction = temp[randi() % temp.size()]
	if direction == LEFT:
		$Sprite.flip_h = true 
	else:
		$Sprite.flip_h = false
	$MoveTimer.wait_time = int(rand_range(1, 4))



# 구매 물품이 있다면 Good,  없다면 Ummm... 돈이 없다면 No Money :(  그리고 rating 평가
func _on_BuyTimer_timeout() -> void:
	$Chatbox.visible = true
	$Tween.interpolate_property($Chatbox, "rect_scale", Vector2(0, 0), Vector2(1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	$ChatTimer.start()
	yield($Tween, "tween_all_completed")
	

func _on_ExitChat_pressed() -> void:
	$Chatbox.visible = false


func _on_ChatTimer_timeout() -> void:
	$Tween.interpolate_property($Chatbox, "rect_scale", Vector2(1, 1), Vector2(0, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	$Chatbox.visible = false
