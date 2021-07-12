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
		"1" : {
			"use" : false, 
			"productId" : 0x0,
			"count" : 0, 
		},
		"2" : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
		},
		"3" : {
			"use" : false,
			"productId" : 0x0,
			"count" : 0, 
		}
	},
}

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
	







