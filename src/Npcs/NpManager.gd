extends Node2D


const NPC = preload("res://src/Npcs/Npc.tscn")
const DAY = 1200.0

const Age1 = 0 # 0 - 19 
const Age2 = 1 # 20 - 39
const Age3 = 2 # 40 - 59
const Age4 = 3 # 60 - 79

const SATIETY_BONUS = 1.3

var region

const Male = 1
const Female = 2

var age_ability = {
	Age1 : {
		"taste" : [3.9, 10],
		"moisture" : [2, 10],
		"satiety" : [3, 8],
		"health" : [0, 3],
	},
	Age2 : {
		"taste" : [2.5, 10],
		"moisture" : [3.2, 10],
		"satiety" : [4, 7],
		"health" : [1.3, 5],		
	},
	Age3 : {
		"taste" : [1, 5.5],
		"moisture" : [2.7, 7.3],
		"satiety" : [1.5, 6],
		"health" : [3.5, 7],		
	},
	Age4 : {
		"taste" : [0, 4.7],
		"moisture" : [2, 5.5],
		"satiety" : [0.5, 6],
		"health" : [5, 10],		
	}
}

var age_income_boost = {
	1 : 5,
	2 : 10,
	3 : 15,
	4 : 20,
	5 : 25,
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
	0xA006 : 0,
	0xA007 : 0,
	0xA008 : 0,
	0xA009 : 0,
}

var matching_age = {
	Age1 : "0-19",
	Age2 : "20-39",
	Age3 : "40-59",
	Age4 : "60-79"
}

var matching_gender = {
	Male : "Male",
	Female : "Female"
}

var logging = {
	"0-19" : {
		"Male": {
			
		},
		"Female" : {
			
		}
	},
	"20-39" : {
		"Male": {
			
		},
		"Female" : {
			
		}
	},
	"40-59" : {
		"Male": {
			
		},
		"Female" : {
			
		}
	},
	"60-79" : {
		"Male": {
			
		},
		"Female" : {
			
		}
	},
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
		

func load_npc(info):
	var npc = NPC.instance() 
	npc.setup(info)
	get_node("/root/Main/Game/Map").add_child(npc)
	
	

func _on_spawn_npc(age_index):
	if not check_rating():
		return 

	randomize()
	var cash = int(rand_range(age_cash[age_index][0], age_cash[age_index][1]))
	# income_level에 맞는 소지금 증가
	cash = int(cash * (1 + age_income_boost[region["income_level"]] / 100))
	
	var value = int(rand_range(0, 100))
	var gender:int
	if value <= region["gender"]["male"]:
		gender = Male
	else:
		gender = Female
	
	var suggestion = setup_npc_suggestion(age_index, gender, cash)
	if suggestion <= 0:
		#print("Lack of Cash!")
		return
	
	
	load_npc({
		"suggestion" : suggestion,
		"gender" : gender,
		"age" : age_index,
		"cash" : cash
	})
	
	
	### Debugging!!
	"""
	print("Spawn NPC! age : {age}, gender : {gender}, suggestion : {suggestion}".format({
		"age" : age_index,
		"gender" : gender,
		"suggestion" : Products.get_products()[suggestion]["name"]
	}))
	"""

	"""
	var age_str = matching_age[age_index]
	var gender_str = matching_gender[gender]
	var product_str = Products.get_products()[suggestion]["name"]
	
	if not logging[age_str][gender_str].has(product_str):
		logging[age_str][gender_str][product_str] = 1
	else:
		logging[age_str][gender_str][product_str] += 1

	
	print("=================================================")
	for age in logging:
		print("Age : {age}".format({"age" : age}))
		print("[Male]")
		for product_name in logging[age]["Male"]:
			print("{product} : {count}".format({"product" : product_name, "count" : logging[age]["Male"][product_name]}))
		
		print("[Female]")
		for product_name in logging[age]["Female"]:
			print("{product} : {count}".format({"product" : product_name, "count" : logging[age]["Female"][product_name]}))
	print("=================================================")
	"""

# 추천하는 아이템 ID 반환
func setup_npc_suggestion(age_index, gender, cash):
	# 이제 생성되는 시간과 평일인지 주말인지, 뉴스 영향 및 나이대에 따른 니즈 등등 설정 + 소지금도 체크

	var state = age_ability[age_index]
	var goal = {
		"taste" : 0,
		"moisture" : 0, 
		"satiety" : 0,
		"health" : 0,
	}
	for ability in state:
		goal[ability] = stepify(rand_range(state[ability][0], state[ability][1]), 0.1)
	
	# Set Gender Bonus 
	setup_gender_effect(goal, gender)
	# Set Time Bonus 
	setup_time_effect(goal)
	# Set News Bonus 
	#setup_news_effect(goal)
	
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
			if temp == min_value and suggestion != 0:
				if product["sell"] > products[suggestion]["sell"]:
					continue 

			min_value = temp
			suggestion = product["id"]
	
	
	return suggestion

# 젠더 버프, Female : taste 10% health 10% Male : satiety : 10% 증가 moisture : 10%
func setup_gender_effect(goal, gender):
	var value = 0
	if gender == Female:
		value = goal["taste"]
		value = stepify(value * 1.1, 0.1)
		if value >= 10:
			value = 10
		goal["taste"] = value 
		
		value = goal["health"]
		value = stepify(value * 1.1, 0.1)
		if value >= 10:
			value = 10
		goal["health"] = value 
		
	elif gender == Male:
		value = goal["satiety"]
		value = stepify(value * 1.1, 0.1)
		if value >= 10:
			value = 10
		goal["satiety"] = value 

		value = goal["moisture"]
		value = stepify(value * 1.1, 0.1)
		if value >= 10:
			value = 10
		goal["moisture"] = value 


func setup_time_effect(goal):
	var hour = State.get_time()["hour"]
	
	# 식사 시간 보너스 허기의 목표치를 30% 늘린다. 단 10이 넘어가면 10으로 설정 기존 상품 능력치 너프
	if (hour >= 6 and hour <= 8) or (hour >= 12 and hour <= 14) or (hour >= 18 and hour <= 20):
		var value = goal["satiety"]
		value = stepify(value * SATIETY_BONUS, 0.1)
		if value >= 10:
			value = 10
		goal["satiety"] = value

	
	
# 특정 제품에 대한 홍보라면 30%확률로 goal확인하지 않고 해당 제품 구매 단) cash 체크
func setup_news_effect(goal):
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



