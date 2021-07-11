extends Node2D


var map = preload("res://src/Map/Map.tscn") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func start_game():
	 load_map()
	
	
func setup():
	pass
	
func load_map():
	var map_instance = map.instance()
	add_child(map_instance)
	
	
func _on_error():
	pass
