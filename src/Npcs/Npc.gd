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

func _ready() -> void:
	position = get_parent().get_spawn_npc_position()


func _physics_process(delta: float) -> void:
	velocity.x += 15 * delta
	velocity.y += 50
	velocity = move_and_slide(velocity, Vector2.UP)


func get_random_texture():
	randomize()
	return int(rand_range(0, 2))
	
# NPC를 우클릭하면 상세탭이 나오고 물건 구매나, 돈이 부족할 때, 원하는 상품이 없을 떄 메시지를 띄운다.

# Info  suggestion이 0인거은 돈 부족으로 인한 구매 불가
# suggestion, age, gender, cash 
func setup(info:Dictionary):
	$Sprite.texture = npc_texture_list[get_random_texture()]
