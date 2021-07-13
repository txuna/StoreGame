extends RigidBody2D

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"

const GRAVITY = 9.8


var dragging = false 
var held = false

signal clicked

var id = 0x0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()

func setup(product_id):
	id = product_id

func get_id():
	return id

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)
			
		if held and event.button_index == BUTTON_WHEEL_UP:
			rotate(0.05)
			
		if held and event.button_index == BUTTON_WHEEL_DOWN:
			rotate(-0.05)
					
func pickup():
	if held:
		return
	mode = RigidBody2D.MODE_STATIC
	held = true
		

func drop(impulse=Vector2.ZERO):
	if held:
		mode = RigidBody2D.MODE_RIGID
		apply_central_impulse(impulse)
		held = false


func _on_VisibilityNotifier2D_viewport_exited(viewport: Viewport) -> void:
	State.set_product_count(id, 1, -1)
	queue_free()
