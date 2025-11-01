class_name Nameplate
extends Control

@onready var name_label = $NameLabel
@onready var class_label = $ClassLabel

var hero_name: String
var hero_class: String

func set_hero_name(value: String):
	hero_name = value
	name_label.text = hero_name
	
func set_hero_class(value: String):
	hero_class = value
	class_label.text = hero_class
