extends Node

var ProductList = {
	0xA000 : {
		"name" : "Cola",
		"id" : 0xA000, 
		"buy" : 700,
		"sell" : 1100,
	},
	0xA001 : {
		"name" : "Milk",
		"id" : 0xA001, 
		"buy" : 500,
		"sell" : 700,
	},
	0xA002 : {
		"name" : "SandWich",
		"id" : 0xA002, 
		"buy" : 800,
		"sell" : 1300,
	},
}


func get_products():
	return ProductList
