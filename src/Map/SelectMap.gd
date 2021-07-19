extends TextureRect

const NEW = 0
const CONTINUE = 1

signal GameStart

var region:String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	region = "A"


func _on_Exitbtn_pressed() -> void:
	$RegionDetail/TextureRect.visible = false


func _on_StartBtn_pressed() -> void:
	State.set_region(region)
	emit_signal("GameStart", NEW)
	queue_free()


func _on_ConvenienceStore_pressed(extra_arg_0: String) -> void:
	region = extra_arg_0
	$RegionDetail/TextureRect.visible = true
	show_detail()
	

func show_detail():
	$RegionDetail.visible = true
	var region_info = Region.get_region(region)
	$RegionDetail/TextureRect/AgeGroupValue.text = "0~19({0-19}%), 20~39({20-39}%)\n40~59({40-59}%), 60~79({60-79}%)".format({
		"0-19" : region_info["age_group"]["0-19"] * 10,
		"20-39" : region_info["age_group"]["20-39"] * 10,
		"40-59" : region_info["age_group"]["40-59"] * 10,
		"60-79" : region_info["age_group"]["60-79"] * 10})
	$RegionDetail/TextureRect/GenderRatioValue.text = "Male : {male}%, Female : {female}%".format({"male" : region_info["gender"]["male"], "female" : region_info["gender"]["female"]})
	$RegionDetail/TextureRect/IncomeLevelValue.text = "{income} Level".format({"income" : region_info["income_level"]})
	$RegionDetail/TextureRect/PopulationValue.text = str(region_info["population"]) +"people"
