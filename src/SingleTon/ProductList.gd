extends Node

var ProductList = {
	0xA000 : {
		"name" : "Cola",
		"id" : 0xA000, 
		"buy" : 700,
		"sell" : 1100,
		"scene" : preload("res://src/Product/Cola.tscn"),
	},
	0xA001 : {
		"name" : "Milk",
		"id" : 0xA001, 
		"buy" : 500,
		"sell" : 700,
		"scene" : preload("res://src/Product/Milk.tscn"),
	},
	0xA002 : {
		"name" : "SandWich",
		"id" : 0xA002, 
		"buy" : 800,
		"sell" : 1300,
		"scene" : preload("res://src/Product/SandWich.tscn"),
	},
}


func get_products():
	return ProductList
