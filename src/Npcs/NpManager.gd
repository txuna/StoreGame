extends Node2D


const NPC = preload("res://src/Npcs/Npc.tscn")

const SATIETY_BONUS = 1.3

var region


var age_ability = {
	Global.Age1 : {
		"taste" : [3.9, 10],
		"moisture" : [2, 10],
		"satiety" : [3, 8],
		"health" : [0, 3],
	},
	Global.Age2 : {
		"taste" : [2.5, 10],
		"moisture" : [3.2, 10],
		"satiety" : [4, 7],
		"health" : [1.3, 5],		
	},
	Global.Age3 : {
		"taste" : [1, 5.5],
		"moisture" : [2.7, 7.3],
		"satiety" : [1.5, 6],
		"health" : [3.5, 7],		
	},
	Global.Age4 : {
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
	Global.Age1 : [300, 4700],
	Global.Age2 : [1500, 10000],
	Global.Age3 : [1300, 7200],
	Global.Age4 : [500, 5200],
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
	Global.Age1 : "0-19",
	Global.Age2 : "20-39",
	Global.Age3 : "40-59",
	Global.Age4 : "60-79"
}

var matching_gender = {
	Global.Male : "Male",
	Global.Female : "Female"
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

var age_suggestion = {
	Global.Age1 : [0xA006, 0xA00B],
	Global.Age2 : [0xA00C, 0xA009],
	Global.Age3 : [0xA00A, 0xA00D],
	Global.Age4 : [0xA00E]
}

var current_npc:int

signal AllNpcExited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	region =  Region.get_region(State.get_pos())
	current_npc = 0

"""
1n : 3n : 4n : 2n으로 생성 

1200/1n 초마다 npc생성
1200/3n 초마다 npc 생성
1200/4n 초마다 npc 생성 
1200/2n 초마다 npc 생성
"""

func stop_manager():
	for timer in $Timers.get_children():
		timer.queue_free()
	

func start_manager():
	var age_index = 0
	var n = region["population"] / 10
	for key in region["age_group"]:
		var value = Global.DAY / (region["age_group"][key] * n)
		var timer = Timer.new() 
		timer.connect("timeout", self, "_on_spawn_npc", [age_index])
		timer.wait_time = stepify(value, 0.1)
		timer.autostart = true
		$Timers.add_child(timer)
		age_index+=1
		

func load_npc(info):
	var npc = NPC.instance() 
	npc.setup(info)
	npc.connect("NpcBuyProduct", get_node("/root/Main/Game"), "_on_npc_buy_product")
	npc.add_to_group("Npcs")
	get_node("/root/Main/Game/Map/InStore/Npcs").add_child(npc)
	

# 상점이 Close상태라서 나가는거랑 그냥 물건 구매후 나가는거 구별해야할듯
func _on_npc_exited():
	pass


func _on_spawn_npc(age_index):
	if current_npc >= Global.MAX_NPC:
		if OS.is_debug_build():
			print("MAX NPC")
		return
	if not check_rating():
		return 

	randomize()
	var cash = int(rand_range(age_cash[age_index][0], age_cash[age_index][1]))
	# income_level에 맞는 소지금 증가
	cash = int(cash * (1 + age_income_boost[region["income_level"]] / 100))
	
	var value = int(rand_range(0, 100))
	var gender:int
	if value <= region["gender"]["male"]:
		gender = Global.Male
	else:
		gender = Global.Female
	
	var suggestion = setup_npc_suggestion(age_index, gender, cash)
	#if suggestion <= 0:
		#print("Lack of Cash!")
	#	return
	
	
	load_npc({
		"suggestion" : suggestion,
		"gender" : gender,
		"age" : age_index,
		"cash" : cash,
		"name" : "James Smith"
	})
	current_npc+=1
	
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
	
	var suggestion = get_age_suggestion(age_index, cash)
	if suggestion != 0:
		return suggestion
	
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

func get_probability(percent)->bool:
	var value = int(rand_range(0, 100))
	if percent <= value:
		return true 
	else:
		return false
	
# percent와 age에따라서 고정 선택값 단 캐쉬가 부족하면 패스
# 0x0 이라면 선택 X 
# 아니라면 선택됨
func get_age_suggestion(age, cash):
	var percent = 10
	var suggestion = 0x0 
	
	if get_probability(percent):
		var temp = age_suggestion[age]
		var id = temp[randi() % temp.size()]
		var price = Products.get_products()[id]["sell"]
		if cash < price:
			return suggestion
		else:
			suggestion = id 
		
	return suggestion


# 젠더 버프, Female : taste 10% health 10% Male : satiety : 10% 증가 moisture : 10%
func setup_gender_effect(goal, gender):
	var value = 0
	if gender == Global.Female:
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
		
	elif gender == Global.Male:
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


func set_current_npc(value, mask):
	current_npc += (value * mask)

