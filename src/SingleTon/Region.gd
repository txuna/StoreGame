extends Node

# 부자 동네일 수록 보유현금이 많지만 rating에 민감함

var RegionList = {
	"A" : {
		"gender" : {
			"male" : 55,
			"female" : 45
		},
		"age_group" : {
			"0-19" :  2,
			"20-39" : 3,
			"40-59" : 3,
			"60-79" : 2, 
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
			"0-19" :  1,
			"20-39" : 4,
			"40-59" : 3,
			"60-79" : 2, 
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
			"0-19" :  3,
			"20-39" : 3,
			"40-59" : 2,
			"60-79" : 2 
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
			"0-19" :  2,
			"20-39" : 2,
			"40-59" : 3,
			"60-79" : 3,
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
			"0-19" :  1,
			"20-39" : 2,
			"40-59" : 2,
			"60-79" : 5 
		},
		"population" : 1400,
		"income_level" : 1
	}
}

func get_region(region):
	return RegionList[region]
