extends Node

# 부자 동네일 수록 보유현금이 많지만 rating에 민감함

var RegionList = {
	"A" : {
		"gender" : {
			"male" : 55,
			"female" : 45
		},
		"age_group" : {
			"0-19" :  25,
			"20-39" : 25,
			"40-59" : 25,
			"60-79" : 25 
		},
		"population" : 1700,
		"income_level" : 3
	},
	"B" : {
		"gender" : {
			"male" : 65,
			"female" : 35
		},
		"age_group" : {
			"0-19" :  10,
			"20-39" : 40,
			"40-59" : 35,
			"60-79" : 15 
		},
		"population" : 2000,
		"income_level" : 4
	},
	"C" : {
		"gender" : {
			"male" : 35,
			"female" : 65
		},
		"age_group" : {
			"0-19" :  30,
			"20-39" : 30,
			"40-59" : 20,
			"60-79" : 20 
		},
		"population" : 2200,
		"income_level" : 5
	},
	"D" : {
		"gender" : {
			"male" : 50,
			"female" : 50
		},
		"age_group" : {
			"0-19" :  10,
			"20-39" : 40,
			"40-59" : 35,
			"60-79" : 15
		},
		"population" : 2400,
		"income_level" : 2
	},
	"E" : {
		"gender" : {
			"male" : 45,
			"female" : 55
		},
		"age_group" : {
			"0-19" :  5,
			"20-39" : 15,
			"40-59" : 30,
			"60-79" : 50 
		},
		"population" : 1400,
		"income_level" : 1
	}
}

func get_region(region):
	return RegionList[region]
