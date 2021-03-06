extends Node2D


var game 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	#SaveData.load_data()
	var title = $UiLayer/TitleUI
	title.visible = true
	title.connect("GameStart", self, "_on_game_start")
	title.connect("SelectMap", self, "load_select_map")
	
	var select_map = $UiLayer/SelectMap
	select_map.connect("GameStart", self, "_on_game_start")
	
	
func load_select_map():
	$UiLayer/SelectMap.visible = true
	
	
func _on_game_start(type):
	if type == Global.NEW:
		SaveData.load_new_game()
		
	elif type == Global.CONTINUE:
		SaveData.load_data()
		
	var title = $UiLayer/TitleUI
	title.visible = false
	game = $Game
	if game.has_method("start_game"):
		game.start_game()
	else:
		if OS.is_debug_build():
			_on_error("Game dont had start_game method")
		
		
func _on_error(msg:String):
	print(msg)


func _on_Main_tree_exiting() -> void:
	SaveData.save_data("Main")
