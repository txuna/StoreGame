extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


# 옵션 박스로 선택된 것과 일치하는 상품 코드인지 확인하여 증가 
func _on_DetectProduct_body_entered(body: Node) -> void:
	pass # Replace with function body.


func _on_DetectProduct_body_exited(body: Node) -> void:
	pass # Replace with function body.
