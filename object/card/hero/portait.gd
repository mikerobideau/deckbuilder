class_name HeroPortrait extends Control

@onready var icon = $Icon
@onready var border_outer = $CenterContainer/BorderOuter
@onready var border_inner = $CenterContainer/BorderInner
@onready var background = $CenterContainer/Background

func _ready():
	pass

func set_texture(value):
	icon.texture = value
	
func set_outer_color(color: Color):
	border_outer.modulate = color
	
func set_inner_color(color: Color):
	border_inner.modulate = color

func set_background_color(color: Color):
	background.modulate = color

func set_icon_color(color: Color):
	icon.modulate = color
