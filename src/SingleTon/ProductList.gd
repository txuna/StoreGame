extends Node

# shelf-life : 유통기한 - days
# moisture : 수분함유량 100%만점
# satiety : 포만감 : 100% 만점 
# health :  10점 만점
# taste : 10점 만점

"""
1. 콜라 
2. 우유 
3. 샌드위치 
4. 햄버거 
5. 김밥
6. 물 
7. 사탕
8. 초코우유 
9. 초콜릿 
10. 담배
11. 레드와인 + 화이트와인
12. 비타민(병)
13. 인삼알약 
14. 도시락 
15. 감자칩 
16. 바나나칩
17. 감자 
18. 당근 
19. 사과
20. 탄산수
"""

const Cool = 1
const Warm = 2
const Lukewarm = 3

var ProductList = {
	0xA000 : {
		"name" : "Cola",
		"id" : 0xA000, 
		"buy" : 700,
		"sell" : 1200,
		"scene" : preload("res://src/Product/Cola.tscn"),
		"shelf_life" : 3.0, 
		"moisture" : 6.5,
		"satiety" : 0.0,
		"health" : -0.7,
		"temperature" : Cool,
		"taste" : 7.0,
	},
	0xA001 : {
		"name" : "Milk",
		"id" : 0xA001, 
		"buy" : 700,
		"sell" : 950,
		"scene" : preload("res://src/Product/Milk.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 5.6,
		"satiety" : 0.6,
		"health" : 2.0,
		"temperature" : Cool,
		"taste" : 2.2,
	},
	0xA002 : {
		"name" : "SandWich",
		"id" : 0xA002, 
		"buy" : 900,
		"sell" : 1400,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : -0.1,
		"satiety" : 3.0,
		"health" : 4.0,
		"temperature" : Lukewarm,
		"taste" : 3.0,
	},
	0xA003 : {
		"name" : "Hamburger",
		"id" : 0xA003, 
		"buy" : 1300,
		"sell" : 2000,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : -0.3,
		"satiety" : 6.5,
		"health" : -0.3,
		"temperature" : Lukewarm,
		"taste" : 5.5,
	},
	0xA004 : {
		"name" : "Gimbap",
		"id" : 0xA004, 
		"buy" : 400,
		"sell" : 850,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : -0.3,
		"satiety" : 3.8,
		"health" : 3.0,
		"temperature" : Lukewarm,
		"taste" : 3.3,
	},
	0xA005 : {
		"name" : "Water",
		"id" : 0xA005, 
		"buy" : 300,
		"sell" : 600,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 4.0, 
		"moisture" : 7.0,
		"satiety" : 0.3,
		"health" : 2.5,
		"temperature" : Cool,
		"taste" : 1.5,
	},
	0xA006 : {
		"name" : "CandyBar",
		"id" : 0xA006, 
		"buy" : 250,
		"sell" : 500,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 3.0, 
		"moisture" : -0.2,
		"satiety" : 0.3,
		"health" : -0.1,
		"temperature" : Lukewarm,
		"taste" : 7.5,
	},
	0xA007 : {
		"name" : "Choco Milk",
		"id" : 0xA007, 
		"buy" : 1200,
		"sell" : 1650,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 2.0, 
		"moisture" : 5.3,
		"satiety" : 0.1,
		"health" : -0.1,
		"temperature" : Cool,
		"taste" : 5.0,
	},
	0xA008 : {
		"name" : "Chocolate",
		"id" : 0xA008, 
		"buy" : 900,
		"sell" : 1300,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 3.0, 
		"moisture" : -0.2,
		"satiety" : 1.5,
		"health" : -0.2,
		"temperature" : Lukewarm,
		"taste" : 7.3,
	},
	0xA009 : {
		"name" : "Cigal",
		"id" : 0xA009, 
		"buy" : 2000,
		"sell" : 2700,
		"scene" : preload("res://src/Product/SandWich.tscn"),
		"shelf_life" : 5.0, 
		"moisture" : 0.0,
		"satiety" : 0.0,
		"health" : -1.0,
		"temperature" : Lukewarm,
		"taste" : 8.5,
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
