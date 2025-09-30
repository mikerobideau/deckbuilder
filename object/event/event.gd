class_name Event
extends BaseCard

func _ready() -> void:
	_setup()
	
func set_health(new_health: int):
	data.health = new_health
	
func get_health():
	return data.health
		
func take_damage(amount: int):
	var new_health = get_health() - amount
	if new_health < 0:
		new_health = 0
	set_health(new_health)
	print_debug('Event - health set to ' + str(get_health()))
