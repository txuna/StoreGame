extends Node2D


var game 

const NEW = 0
const CONTINUE = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	#SaveData.load_data()
	var title = $UiLayer/TitleUI
	title.visible = true
	title.connect("GameStart", self, "_on_game_start")
	
	
func _on_game_start(type):
	if type == NEW:
		SaveData.load_new_game()
		
	elif type == CONTINUE:
		SaveData.load_data()
		
	var title = $UiLayer/TitleUI
	title.visible = false
	game = $Game
	if game.has_method("start_game"):
		game.start_game()
	else:
		_on_error("Game dont had start_game method")
		
		
func _on_error(msg:String):
	print(msg)
