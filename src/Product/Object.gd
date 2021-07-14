extends RigidBody2D


const GAME_DAY = 1800
const GAME_HOUR = 75

var dragging = false 
var held = false

signal clicked

var id = 0x0

var product_state = true # 유통기한 전인가 후인가

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = Timer.new()
	timer.name = "ShelfLifeTimer"
	timer.wait_time = Products.get_products()[id]["shelf_life"] * 1800
	timer.one_shot = true
	timer.connect("timeout", self, "finish_product_shelf_life") 
	add_child(timer)
	timer.start() 

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()

func setup(product_id):
	id = product_id


# 상품의 유통기한이 지났는지 아닌지 확인하는 코드 
func finish_product_shelf_life():
	product_state = false
	
func get_product_state():
	return product_state

func get_id():
	return id
	
func show_detail():
	$Detail.visible = true
	var product = Products.get_products()[id]
	$Detail/NameValue.text = product["name"]
	
	var remain_shelf_life = get_node("ShelfLifeTimer").wait_time
	var days = remain_shelf_life / GAME_DAY
	remain_shelf_life = int(remain_shelf_life) % GAME_DAY 
	var hours = remain_shelf_life / GAME_HOUR
	
	$Detail/ShelfLifeValue.text = "{day}days {hour}hours".format({"day" : days, "hour" : hours})
	
	if product_state == true:
		$Detail/StateValue.text = "Very Good"
	else:
		$Detail/StateValue.text = "Bad"
	
func close_detail():
	$Detail.visible = false
	

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("clicked", self)
			
		if held and event.button_index == BUTTON_WHEEL_UP:
			rotate(0.05)
			
		if held and event.button_index == BUTTON_WHEEL_DOWN:
			rotate(-0.05)
			
		if event.button_index == BUTTON_RIGHT:
			if event.pressed: 
				show_detail()
			else:
				close_detail()
					
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
