class_name EnemyNamePlate
extends Control

@onready var name_label = $Name

var enemy_name: String

func set_enemy_name(value: String):
	enemy_name = value
	name_label.text = value
