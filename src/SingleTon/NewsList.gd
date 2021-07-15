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
			"ko" : "기상청에따르면 {Today}부터 본격적인 {sweltering}가 시작된다고 보고있습니다. ",
			"en" : ""
		},
		"effect" : {
			"type" : Product, # or Gender or  Product 
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





