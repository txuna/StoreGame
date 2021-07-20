extends Node2D


const DAY = 1200.0

const Age1 = 0 # 0 - 19 
const Age2 = 1 # 20 - 39
const Age3 = 2 # 40 - 59
const Age4 = 3 # 60 - 79

var region

const Male = 1
const Female = 2

var age_ability = {
	Age1 : {
		"taste" : [4, 9],
		"moisture" : [2, 8],
		"satiety" : [3, 9],
		"health" : [0, 3],
	},
	Age2 : {
		"taste" : [3, 7],
		"moisture" : [3, 8],
		"satiety" : [4, 7],
		"health" : [1, 5],		
	},
	Age3 : {
		"taste" : [1, 5],
		"moisture" : [3, 6],
		"satiety" : [1, 6],
		"health" : [3, 7],		
	},
	Age4 : {
		"taste" : [0, 4],
		"moisture" : [2, 5],
		"satiety" : [0, 6],
		"health" : [5, 9],		
	}
}

var age_cash = {
	Age1 : [300, 4700],
	Age2 : [1500, 10000],
	Age3 : [1300, 7200],
	Age4 : [500, 5200],
}


var test = {
	0xA000 : 0,
	0xA001 : 0,
	0xA002 : 0,
	0xA003 : 0,
	0xA004 : 0,
	0xA005 : 0,
}

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
	if not check_rating():
		return 

	randomize()
	var value = int(rand_range(0, 100))
	var gender:int
	if value <= region["gender"]["male"]:
		gender = Male
	else:
		gender = Female
	
	var suggestion = setup_npc_suggestion(age_index)
	if suggestion <= 0:
		print("Lack of Cash!")
		return
	
	print("Spawn NPC! age : {age}, gender : {gender}, suggestion : {suggestion}".format({
		"age" : age_index,
		"gender" : gender,
		"suggestion" : Products.get_products()[suggestion]["name"]
	}))
	test[suggestion]+=1
	print(test)

# 추천하는 아이템 ID 반환
func setup_npc_suggestion(age_index):
	# 이제 생성되는 시간과 평일인지 주말인지, 뉴스 영향 및 나이대에 따른 니즈 등등 설정 + 소지금도 체크
	var cash = int(rand_range(age_cash[age_index][0], age_cash[age_index][1]))

	var state = age_ability[age_index]
	var goal = {
		"taste" : 0,
		"moisture" : 0, 
		"satiety" : 0,
		"health" : 0,
	}
	for ability in state:
		goal[ability] = stepify(rand_range(state[ability][0], state[ability][1]), 0.1)
	
	# Set Time Bonus 
	#setup_time_effect()
	# Set News Bonus 
	#setup_news_effect()
	# Set Gender Bonus 
	#setup_gender_effect()
	
	# Product List와 비교 남는 능력치가 가장 작은 것이 선발 
	var min_value = 100
	var suggestion = 0
	var products = Products.get_products()

	for id in products:
		var product = products[id]
		var temp = 0
		# 보유 현금보다 비싸다면 패스
		if cash < product["sell"]:
			continue 
			
		for ability in goal:
			var gap = goal[ability] - product[ability]
			if gap > 0:
				temp += gap 
		
		#print(temp)
		# 만약 갭이 작다면
		if temp <= min_value:
			# 기존의 상품보다 비싸다면 pass 
			#if not suggestion == 0 and product["sell"] > products[suggestion]["sell"]:
			#	continue
			min_value = temp
			suggestion = product["id"]
	
	
	return suggestion


func setup_gender_effect():
	pass

func setup_time_effect():
	pass
	
	
func setup_news_effect():
	pass
	

# rating 확률에 따라 npc생성 확률
func check_rating():
	var rating = State.get_rating()
	var pivot = rating / 10 * 100
	pivot = stepify(pivot, 0.1) * 10
	randomize()
	var value = int(rand_range(0, 1000))
	
	#print("pivot : {pivot} and age : {age}".format({"pivot" : pivot, "age" : value}))
	if value <= pivot:
		return true
	else:
		return false



