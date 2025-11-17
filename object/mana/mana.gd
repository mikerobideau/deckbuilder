class_name Mana
extends Control

@onready var supply_label = $Supply

var supply: int

func _ready():
	refresh()
	
func refresh():
	set_supply(Const.MANA_PER_TURN)
	
func spend(value: int):
	var new_supply = max(0, supply - value)
	set_supply(new_supply)
	
func set_supply(value: int):
	supply = value
	_update_label()
	
func _update_label():
	supply_label.text = str(supply)
