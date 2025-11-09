class_name Mana
extends Control

@onready var supply_label = $Supply

var supply: int

func _ready():
	set_supply(0)
	
func set_supply(value: int):
	supply = value
	_update_label()
	
func _update_label():
	supply_label.text = str(supply)
