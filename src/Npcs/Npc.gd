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


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	pass


func get_random_texture():
	pass
	

# Info 
# suggestion, age, gender, cash 
func setup(info:Dictionary):
	$Sprite.texture = get_random_texture()
