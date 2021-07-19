extends Node2D


const DAY = 1200.0

const Age1 = 0 # 0 - 19 
const Age2 = 1 # 20 - 39
const Age3 = 2 # 40 - 59
const Age4 = 3 # 60 - 79

var region

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	region =  Region.get_region(State.get_pos())

"""
1n : 3n : 4n : 2n으로 생성 

1200/1n 초마다 npc생성
1200/3n 초마다 npc 생성
1200/4n 초마다 npc 생성 
1200/2n 초마다 npc 생성
"""

func start_manager():
	var age_index = 0
	var n = region["population"] / 10
	for key in region["age_group"]:
		var value = DAY / (region["age_group"][key] * n)
		var timer = Timer.new() 
		timer.connect("timeout", self, "_on_spawn_npc", [age_index])
		timer.wait_time = stepify(value, 0.1)
		timer.autostart = true
		add_child(timer)
		age_index+=1
		

func _on_spawn_npc(age_index):
	if check_rating():
		print("spawn! : {age}".format({"age" : age_index}))
	else:
		print("Failed spawn : {age}".format({"age" : age_index}))


func check_rating():
	var rating = State.get_rating()
	var pivot = rating / 10 * 100
	pivot = stepify(pivot, 0.1) * 10
	var value = int(rand_range(0, 1000))
	
	print("pivot : {pivot} and age : {age}".format({"pivot" : pivot, "age" : value}))
	if value <= pivot:
		return true
	else:
		return false
	








