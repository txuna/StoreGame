extends Control


const STATE = 1
const SALES = 2
const STOCK = 3 

onready var StateTab = $PosContainer/PosBack/State
onready var SalesTab = $PosContainer/PosBack/Sales
onready var StockTab = $PosContainer/PosBack/Stock

var current_tab = STATE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var taps = $PosContainer/PosBack
	for tap in taps.get_children():
		tap.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_TextureButton_pressed() -> void:
	visible = false


func _on_StateBtn_pressed() -> void:
	$PosContainer/Tabs/StateBtn.pressed = true
	$PosContainer/Tabs/SalesBtn.pressed = false
	$PosContainer/Tabs/StockBtn.pressed = false
	StateTab.visible = true
	SalesTab.visible = false
	StockTab.visible = false
	

func _on_SalesBtn_pressed() -> void:
	$PosContainer/Tabs/StateBtn.pressed = false
	$PosContainer/Tabs/SalesBtn.pressed = true
	$PosContainer/Tabs/StockBtn.pressed = false
	SalesTab.visible = true
	StateTab.visible = false
	StockTab.visible = false

func _on_StockBtn_pressed() -> void:
	$PosContainer/Tabs/StateBtn.pressed = false
	$PosContainer/Tabs/SalesBtn.pressed = false
	$PosContainer/Tabs/StockBtn.pressed = true
	StockTab.visible = true
	SalesTab.visible = false
	StateTab.visible = false


