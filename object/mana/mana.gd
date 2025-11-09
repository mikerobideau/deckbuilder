class_name Mana
extends Control

@onready var supply_label = $Supply

var supply: int

func _ready():
	supply = 0
	_update_label()
	
func _update_label():
	supply_label.text = str(supply)
