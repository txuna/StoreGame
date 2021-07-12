extends Node


class_name UIkit

func make_dynamic_font(font_size)->DynamicFont:
	# font 설정
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://assets/font/NanumBarunpenB.ttf")
	dynamic_font.size = font_size
	return dynamic_font
	
func make_label(text:String, font_size:int)->Label:
	var label = Label.new()
	label.text = text
	label.set("custom_fonts/font", make_dynamic_font(font_size))
	label.set("custom_colors/font_color",Color(0,0,0))
	return label


func make_hbox()->HBoxContainer:
	var hbox = HBoxContainer.new()
	return hbox 
	
func make_texture_btn(normal="", pressed="", hover="", disable="")->TextureButton:
	var texture_btn = TextureButton.new()
	if not normal.empty():
		texture_btn.texture_normal = load(normal)
	if not pressed.empty():
		texture_btn.texture_pressed = load(pressed)
	
	if not hover.empty(): 
		texture_btn.texture_hover = load(hover)
	
	if not disable.empty():
		texture_btn.texture_hover = load(disable)	
	
	return texture_btn
