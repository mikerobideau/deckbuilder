class_name ItemNameplate
extends Control

@onready var name_label = $Name

var item_name: String
var hero_class: String

func set_item_name(value: String):
	item_name = value
	name_label.text = value
