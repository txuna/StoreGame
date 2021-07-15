extends Node

# 뉴스를 통해서 영향을 받는 그룹
const AgeGroup = 1
const Gender = 2
const Product = 3


var NewsList = {
	0xB000 : {
		"id" : 0xB000,
		"title" : {
			"ko" : "본격적인 무더위 시작!",
			"en" : ""
		},
		"content" : {
			"ko" : "기상청에따르면 내일부터 3일간 북태평양으로부터 유입되는 고온 다습한 공기가 한반도로의 유입되면서 본격적인 무더위가 시작될것으로 보고 있다. 더불어 탈수증장에 걸리지 않도록 수분기 있는 식품을 자주 사먹기를 권장한다. ",
			"en" : ""
		},
		"effect" : {
			"type" : Product, # or Gender or  AgeGroup
			"detail" : {},
		},
		"open" : false, 
	},
	0xB001 : {
		"id" : 0xB001,
		"title" : {
			"ko" : "",
			"en" : ""
		},
		"content" : {
			"ko" : "",
			"en" : ""
		},
		"effect" : {
			"type" : AgeGroup, # or Gender or  Product 
			"detail" : {},
		},
		"open" : false, 
	},
	0xB002 : {
		"id" : 0xB002,
		"title" : {
			"ko" : "",
			"en" : ""
		},
		"content" : {
			"ko" : "",
			"en" : ""
		},
		"effect" : {
			"type" : AgeGroup, # or Gender or  Product 
			"detail" : {},
		},
		"open" : false, 
	},
}

func setup() -> void:
	var data = SaveData.get_data_news()
	if data.empty():
		return 
	else:
		NewsList = data

func get_newslist():
	return NewsList





