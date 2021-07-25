extends Node

const Monday = 1
const Tuesday = 2
const Wednesday = 3
const Thursday = 4
const Friday = 5
const Satureday = 6
const Sunday = 7

const MAX_CAHS = 10000000

var day = {
	Monday : {
		"value" : Monday,
		"str" : "Monday"
	},
	Tuesday : {
		"value" : Tuesday,
		"str" : "Tuesday"
	},
	Wednesday : {
		"value" : Wednesday,
		"str" : "Wednesday"
	},
	Thursday : {
		"value" : Thursday,
		"str" : "Thursday"
	},
	Friday : {
		"value" : Friday,
		"str" : "Friday"
	},
	Satureday: {
		"value" : Satureday,
		"str" : "Satureday"
	},
	Sunday : {
		"value" : Sunday,
		"str" : "Sunday"
	},
}


var Sales = {
	"total_cash" : 0,
	"rating" : 0, 
	"age" : {
		"0-19" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"20-39" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"40-59" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"60-79" : {
			"count" : 0,
			"product" : {
				
			}
		},
	},
	"time_sale" : {
		"morning" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"afternoon" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"evening" : {
			"count" : 0,
			"product" : {
				
			}
		},
		"midnight" : {
			"count" : 0,
			"product" : {
				
			}
		},
	}
}

""" Stock
0xA000 : {
	"id" : 0xA000,
	"count" : 2
	"shelf_life" : [] # 생각중
},
"""

var StoreState = {
	"name" : "Post Exchange",
	"rating" : 2.0, 
	"pos" : "A",
	"date" : {
		"day" : Monday,
		"time" : {
			"hour" : 6,
			"min" : 00,
			"sec" : 00
		}
	},
	"sales" : {
		"cash" : 6000,
		"total_cash" : 0,
		"yesterday" : Sales.duplicate(true),
		"today" : Sales.duplicate(true),
	},
	# 모든 상품의 개수  
	"total_stock_count" : 0,
	# stock :: 같은 id를 가진 상품이 몇개 있는지 
	"stock" : {

	},
	# 인덱스별로 상품 개별 관리 0~255,
	"products": {
		
	},
	"news" : [
		
	], 
	"display_stand" : {
		0x0001 : {
			"use" : false, 
			"productId" : 0xA000,
			"count" : 0,  #  productId와 상응하는 아이템의 카운트 - basket의 핵심부분만 불러온 부분
		},
		0x0002 : {
			"use" : false,
			"productId" : 0xA000,
			"count" : 0, 
		},
		0x0003 : {
			"use" : false,
			"productId" : 0xA000,
			"count" : 0, 
		}
	},
	"next_display_stand_price" : 1000,
}

func setup() -> void:
	var data = SaveData.get_data_storestate()
	if data.empty():
		return 
	else:
		StoreState = data


## 어차피 프로그램 다시 키면 물건들이 다 창고로 이동하기 때문에 초기화 필요
	for index in get_product_all_index():
		StoreState["products"][index]["in_display"] = false 
		StoreState["products"][index]["display_number"] = 0 

	for display_number in get_all_display_stand():
		StoreState["display_stand"][display_number]["count"] = 0
		
	#print(StoreState["products"])
	#print(StoreState["stock"])

func check_max_min_cash(cash, mask):
	var temp = StoreState["sales"]["cash"] + (cash * mask)
	if temp <= MAX_CAHS and temp >= 0:
		return true
	else:
		return false

func remove_product_index(index):
	if StoreState["products"].has(index):
		StoreState["products"].erase(index)


func set_product_index(index, id, shelf_ife):
	StoreState["products"][index] = {
		"id" : id, 
		"index" : index, 
		"shelf_life" : shelf_ife,
		"display_number" : 0, 
		"in_display" : false, 
		"state" : true
	}
	
# 0~255중에 남는 인덱스 찾기 # 못찾을 시 ? 대응법 필요
func find_free_index():
	var index = 0
	while true:
		if StoreState["products"].has(index):
			index+=1 
			if index >= 256:
				if OS.is_debug_build():
					print("find_free_index too much value") 
				return -1
		else:
			break
		
	return index 
	

func get_product_all_index():
	return StoreState["products"]

func get_product_index(index):
	return StoreState["products"][index]

func change_product_index(index, type:String, value):
	StoreState["products"][index][type] = value
	
	
func get_total_stock_count():
	return StoreState["total_stock_count"]


func set_total_stock_count(count, mask):
	StoreState["total_stock_count"] += (count * mask)


func set_region(region:String):
	StoreState["pos"] = region

func get_storestate():
	return StoreState

func get_display_stand_price():
	return StoreState["next_display_stand_price"]
	
func set_display_stand_price(value):
	StoreState["next_display_stand_price"] *= value  

func get_all_display_stand():
	return StoreState["display_stand"]

func get_displaystand(index):
	return StoreState["display_stand"][index]

func set_displaystand(index, id, use, count):
	if not StoreState["display_stand"].has(index):
		StoreState["display_stand"][index] = {
			"productId" : id,
			"use" : use,
			"count" : count,
		}
	else:
		StoreState["display_stand"][index]["productId"] = id
		StoreState["display_stand"][index]["use"] = use 
		StoreState["display_stand"][index]["count"] = count


func change_displaystand_count(index, count, mask):
	StoreState["display_stand"][index]["count"] += (count * mask)


func set_current_cash(cash, mask):
	if not check_max_min_cash(cash, mask):
		return 
	StoreState["sales"]["cash"] += (cash * mask)

func get_current_cash():
	return StoreState["sales"]["cash"]


func has_product_in_products(index):
	if StoreState["products"].has(index):
		return true
	
	return false
	

func set_product_count(id, count, mask):
	if StoreState["stock"].has(id):
		StoreState["stock"][id]["count"] += (count * mask)
	else:
		StoreState["stock"][id] = {
			"id" : id,
			"count" : count * mask,
		}		

	set_total_stock_count(count, mask)
	

func get_total_product_count(id): 
	if StoreState["stock"].has(id):
		return StoreState["stock"][id]["count"]
	return 0

func get_stock():
	return StoreState["stock"]

func get_time():
	return StoreState["date"]["time"]

func get_day():
	var value = StoreState["date"]["day"]
	return day[value]

func set_time(sec):
	var time = StoreState["date"]["time"]
	time["sec"] += sec 
	while true:
		if time["sec"] >= 60:
			time["sec"] -= 60
			time["min"] += 1
		else:
			break
			
		if time["min"] >= 60:
			time["min"] -= 60
			time["hour"] +=1 
			
		if time["hour"] >= 24:
			StoreState["date"]["day"] += 1
			time["hour"] -= 24
			
		if StoreState["date"]["day"] > Sunday:
			StoreState["date"]["day"] = Monday
						

func get_today_cash():
	return StoreState["sales"]["today"]["total_cash"]

func get_name():
	return StoreState["name"]
	
func get_rating():
	return StoreState["rating"]

func get_total_cash():
	return StoreState["sales"]["total_cash"]
	
func get_pos():
	 return StoreState["pos"]





