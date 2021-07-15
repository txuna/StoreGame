extends Node

const NEAR_SCHOOL = 1
const NEAR_COMPANY = 2
const NEAR_HOUSE = 3

const Monday = 1
const Tuesday = 2
const Wednesday = 3
const Thursday = 4
const Friday = 5
const Satureday = 6
const Sunday = 7

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
	"old" : {
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
	"shelf_life" : []
},
"""

var StoreState = {
	"name" : "Post Exchange",
	"rating" : 0.05, 
	"pos" : NEAR_HOUSE,
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
	"stock" : {

	},
	"news" : [
		
	], 
	"display_stand" : {
		0x0001 : {
			"use" : false, 
			"productId" : 0x0,
			"count" : 0,  #  productId와 상응하는 아이템의 카운트 - basket의 핵심부분만 불러온 부분
			"basket" : {},  #진열대 속에 담긴것 
		},
		0x0002 : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
			"basket" : {},  #진열대 속에 담긴것 
		},
		0x0003 : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
			"basket" : {},  #진열대 속에 담긴것 
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

func set_displaystand(index, id, use, count, basket):
	if not StoreState["display_stand"].has(index):
		StoreState["display_stand"][index] = {
			"productId" : id,
			"use" : use,
			"count" : count,
			"basket" : {}
		}
	else:
		StoreState["display_stand"][index]["productId"] = id
		StoreState["display_stand"][index]["use"] = use 
		StoreState["display_stand"][index]["count"] = count
		StoreState["display_stand"][index]["basket"] = basket


func change_displaystand_count(index, count, mask):
	StoreState["display_stand"][index]["count"] += (count * mask)



func set_current_cash(cash, mask):
	StoreState["sales"]["cash"] += (cash * mask)

func get_current_cash():
	return StoreState["sales"]["cash"]

func set_product_count(id, count, mask):
	if StoreState["stock"].has(id):
		StoreState["stock"][id]["count"] += (count * mask)
	else:
		StoreState["stock"][id] = {
			"id" : id,
			"count" : count * mask,
		}		


func get_total_product_count(id): 
	if StoreState["stock"].has(id):
		return StoreState["stock"][id]["count"]
	return 0


func get_time():
	return StoreState["date"]["time"]

func get_day():
	var value = StoreState["date"]["day"]
	return day[value]


func set_time(sec):
	var time = StoreState["date"]["time"]
	if time["sec"] + sec >= 60:
		var gap = (time["sec"] + sec) - 60
		time["sec"] = gap 
		if time["min"]+1 >= 60:
			time["min"] = 0
			if time["hour"]+1 >= 24:
				time["hour"] = 0
				if StoreState["date"]["day"]+1 > Sunday:
					StoreState["date"]["day"] = Monday
				else:
					StoreState["date"]["day"] += 1
			else:
				time["hour"] += 1
		else:
			time["min"] += 1  
	else:
		time["sec"] += sec

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





