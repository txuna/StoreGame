extends Node

# shelf-life : 유통기한 - days
# moisture : 수분함유량 100%만점
# satiety : 포만감 : 100% 만점 
# health :  10점 만점
# taste : 10점 만점

const Cool = 1
const Warm = 2
const Lukewarm = 3

var ProductList = {
	0xA000 : {
		"name" : "Cola",
		"id" : 0xA000, 
		"buy" : 700,
		"sell" : 1100,
		"scene" : preload("res://src/Product/Cola.tscn"),
		"shelf_life" : 3.0, 
		"moisture" : 6.5,
		"satiety" : 0.0,
		"health" : -0.5,
		"temperature" : Cool,
		"taste" : 7.0,
	},
	0xA001 : {
		"name" : "Milk",
		"id" : 0xA001, 
		"buy" : 500,
		"sell" : 700,
		"scene" : preload("res://src/Product/Milk.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 5.5,
		"satiety" : 0.5,
		"health" : 1.5,
		"temperature" : Cool,
		"taste" : 2.0,
	},
	0xA002 : {
		"name" : "SandWich",
		"id" : 0xA002, 
		"buy" : 800,
		"sell" : 1300,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 0.0,
		"satiety" : 3.0,
		"health" : 3.8,
		"temperature" : Lukewarm,
		"taste" : 2.8,
	},
	0xA003 : {
		"name" : "Hamburger",
		"id" : 0xA003, 
		"buy" : 1100,
		"sell" : 1500,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 0.0,
		"satiety" : 5.5,
		"health" : 0.5,
		"temperature" : Lukewarm,
		"taste" : 5.0,
	},
	0xA004 : {
		"name" : "Gimbap",
		"id" : 0xA004, 
		"buy" : 500,
		"sell" : 800,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 0.0,
		"satiety" : 3.5,
		"health" : 2.7,
		"temperature" : Lukewarm,
		"taste" : 3.0,
	},
	0xA005 : {
		"name" : "Water",
		"id" : 0xA005, 
		"buy" : 500,
		"sell" : 800,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 4.0, 
		"moisture" : 8.5,
		"satiety" : 0.5,
		"health" : 3.5,
		"temperature" : Cool,
		"taste" : 1.5,
	},
}

func get_temperature_str(tem):
	var dict = {
		Cool : "Cool",
		Lukewarm : "Lukewarm",
		Warm : "Warm"
	}
	return dict[tem]

func get_products():
	return ProductList
