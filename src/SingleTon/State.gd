extends Node

const NEAR_SCHOOL = 1
const NEAR_COMPANY = 2
const NEAR_HOUSE = 3


var Sales = {
	"total_money" : 0,
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
		"money" : 0,
		"tatal_money" : 0,
		"yesterday" : Sales.duplicate(true),
		"today" : Sales.duplicate(true),
	},
	"display_stand" : {
		"1" : {
			"use" : false, 
			"productId" : 0x0
		},
		"2" : {
			"use" : false,
			"productId" : 0x0
		},
		"3" : {
			"use" : false,
			"productId" : 0x0
		}
	},
}

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
	







