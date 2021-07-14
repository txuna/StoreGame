extends Node

# shelf-life : 유통기한 - days
# moisture : 수분함유량 100%만점
# satiety : 포만감 : 100% 만점 
# health :  10점 만점
# taste : 10점 만점

const Cool = 1
const Hot = 2
const Normal = 3

var ProductList = {
	0xA000 : {
		"name" : "Cola",
		"id" : 0xA000, 
		"buy" : 700,
		"sell" : 1100,
		"scene" : preload("res://src/Product/Cola.tscn"),
		"shelf_life" : 6, 
		"moisture" : 65,
		"satiety" : 5,
		"health" : 1,
		"temperature" : Cool,
		"taste" : 7,
	},
	0xA001 : {
		"name" : "Milk",
		"id" : 0xA001, 
		"buy" : 500,
		"sell" : 700,
		"scene" : preload("res://src/Product/Milk.tscn"),
		"shelf_life" : 2, 
		"moisture" : 60,
		"satiety" : 25,
		"health" : 4,
		"temperature" : Cool,
		"taste" : 2,
	},
	0xA002 : {
		"name" : "SandWich",
		"id" : 0xA002, 
		"buy" : 800,
		"sell" : 1300,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 3, 
		"moisture" : 65,
		"satiety" : 35,
		"health" : 3,
		"temperature" : Normal,
		"taste" : 5,
	},
}

func get_temperature_str(tem):
	var dict = {
		Cool : "Cool",
		Normal : "Normal",
		Hot : "Hot"
	}
	return dict[tem]

func get_products():
	return ProductList
