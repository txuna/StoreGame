extends Node

const NEAR_SCHOOL = 1
const NEAR_COMPANY = 2
const NEAR_HOUSE = 3


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
},
"""

var StoreState = {
	"name" : "Post Exchange",
	"rating" : 0, 
	"pos" : NEAR_HOUSE,
	"date" : {
		"year" : 2021,
		"month" : 7,
		"day" : 11,
		"time" : {
			"hour" : 12,
			"min" : 00,
			"sec" : 00
		}
	},
	"sales" : {
		"cash" : 6000,
		"tatal_cash" : 0,
		"yesterday" : Sales.duplicate(true),
		"today" : Sales.duplicate(true),
	},
	"stock" : {

	},
	"display_stand" : {
		0x0001 : {
			"use" : false, 
			"productId" : 0x0,
			"count" : 0, 
		},
		0x0002 : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
		},
		0x0003 : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
		}
	},
	"next_display_stand_price" : 1000,
}

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
			"count" : count
		}
	else:
		StoreState["display_stand"][index]["productId"] = id
		StoreState["display_stand"][index]["use"] = use 
		StoreState["display_stand"][index]["count"] = count

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
			"count" : count * mask
		}		


func get_total_product_count(id): 
	if StoreState["stock"].has(id):
		return StoreState["stock"][id]["count"]
	
	return 0


func get_time()->String:
	return "{hour}:{min}:{sec}".format({
		"hour" : StoreState["date"]["time"]["hour"],
		"min" : StoreState["date"]["time"]["min"],
		"sec" : StoreState["date"]["time"]["sec"],
	})


func set_time(sec=0):
	StoreState["date"]["time"]["sec"]+=sec
"""
	if StoreState["date"]["time"]["sec"] + sec >= 60:
		pass
"""
	







