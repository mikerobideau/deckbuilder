class_name UnitCard
extends BaseCard

@export var health: int
		
func take_damage(amount: int):
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	health = new_health

func _on_data_set():
	health = data.max_health
