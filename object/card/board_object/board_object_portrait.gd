class_name BoardObjectPortrait 
extends Control

@onready var icon = $Icon

func set_texture(value):
	icon.texture = value
