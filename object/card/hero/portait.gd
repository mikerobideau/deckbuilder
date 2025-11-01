class_name Portrait extends Control

@onready var icon = $Icon

func _ready():
	pass

func set_texture(value):
	icon.texture = value
