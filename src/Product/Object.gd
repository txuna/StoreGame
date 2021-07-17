extends RigidBody2D


const GAME_DAY = 1800
const GAME_HOUR = 75

var dragging = false 
var held = false

signal clicked

var info:Dictionary


# Products.get_products()[id]["shelf_life"] * 1800
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var timer = Timer.new() 
	timer.name = "ShelfTimer"
	timer.wait_time = 1
	timer.connect("timeout", self, "check_shelf_life")
	add_child(timer)
	timer.start() 
	

func _physics_process(delta):
	if held:
		global_transform.origin = get_global_mouse_position()


func setup(arg_index, arg_id):
	info = State.get_product_index(arg_index)


func check_shelf_life():
	if info["shelf_life"] <= 0:
		info["state"] = false 
		get_node("ShelfTimer").stop()
		
	else:
		info["shelf_life"] -= 1		


func get_product_index():
	return info["index"]
	
# 상품의 유통기한이 지났는지 아닌지 확인하는 코드 
func finish_product_shelf_life():
	info["state"] = false
	
func get_remain_shelf_life_time():
	return info["shelf_life"]
	
func get_product_state():
	return info["state"]

func get_id():
	return info["id"]
	
func set_display_number(number):
	info["display_number"] = number
	
func get_display_number():
	return info["display_number"]
	
func is_display():
	return info["in_display"]
	
func set_is_display(value):
	info["in_display"] = value
	
func show_detail():
	$Detail.visible = true
	var product = Products.get_products()[info["id"]]
	$Detail/NameValue.text = product["name"]
	
	var remain_shelf_life = get_remain_shelf_life_time()
	var days = int(remain_shelf_life / GAME_DAY)
	remain_shelf_life = int(remain_shelf_life) % GAME_DAY 
	var hours = remain_shelf_life / GAME_HOUR
	
	$Detail/ShelfLifeValue.text = "{day}days {hour}hours".format({"day" : days, "hour" : hours})
	
	if info["state"] == true:
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
			rotate(-0.07)
			
		if held and event.button_index == BUTTON_WHEEL_DOWN:
			rotate(0.07)
			
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
	State.set_product_count(info["id"], 1, -1)
	State.remove_product_index(info["index"])
	queue_free()
