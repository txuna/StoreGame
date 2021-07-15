extends Node

const PATH = "user://save.json"



# 세이브시 News, StoreState 가져와서 저장 
# 로드시 파일읽고 News 및 StoreState에 대입



var data = {
	"StoreState" : {},
	"News" : {}, 
}

func save_data():
	var file = File.new() 
	var error = file.open(PATH, File.WRITE)
	if error == OK:
		data["StoreState"] = State.get_storestate()
		data["News"] = NewsList.get_newslist()
		file.store_var(data) 
		file.close()
	else:
		print("save_data ERROR")
		return # ERROR
	

func load_new_game():
	save_data()
	load_data()

# once : load_data함수가 한번 실패했을 시 한번 더 기회를 주는 매개변수 
	
func load_data(once=true):
	var file = File.new() 
	if not file.file_exists(PATH):
		if once == false:
			print("load_data once - isn't existed file")
			return #ERROR! 
		else:
			save_data()
			load_data(false)
		
	var error = file.open(PATH, File.READ)
	if error == OK:
		data = file.get_var() 
		file.close()
	else:
		print("load_data ERROR")
		return #ERROR

func get_data_storestate():
	return data["StoreState"]
	
	
func get_data_news():
	return data["News"]	
	
