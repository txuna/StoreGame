extends Node2D


var game 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()


func setup():
	
	var title = $UiLayer/TitleUI
	title.visible = true
	title.connect("GameStart", self, "_on_game_start")
	
	
func _on_game_start():
	var title = $UiLayer/TitleUI
	title.visible = false
	game = $Game
	if game.has_method("start_game"):
		game.start_game()
	else:
		_on_error("Game dont had start_game method")
		
		
func _on_error(msg:String):
	print(msg)
