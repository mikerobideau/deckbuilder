class_name Health
extends MarginContainer

signal base_health_depleted()

@onready var label = $Label

var health: int

func set_health(new_health: int):
	health = new_health
	label.text = str(health) + 'HP'

func take_damage(amount: int):
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	set_health(new_health)
	if new_health == 0:
		base_health_depleted.emit()
