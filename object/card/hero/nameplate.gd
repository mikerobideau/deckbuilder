class_name HeroNameplate
extends Control

@onready var name_plate = $NamePlate
@onready var name_label = $NameLabel
@onready var class_plate = $ClassPlate
@onready var class_label = $ClassLabel

var hero_name: String
var hero_class: String

func set_hero_name(value: String):
	hero_name = value
	name_label.text = hero_name
	
func set_hero_class(value: String):
	hero_class = value
	class_label.text = hero_class

func set_name_plate_color(color: Color):
	name_plate.modulate = color
	
func set_name_plate_font_color(color: Color):
	name_label.add_theme_color_override("font_color", color)

func set_class_plate_color(color: Color):
	class_plate.modulate = color

func set_class_plate_font_color(color: Color):
	class_label.add_theme_color_override("font_color", color)
