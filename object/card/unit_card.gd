class_name UnitCard
extends BaseCard

@export var health: int

var health_label: Label
		
func _ready():
	_setup()
	_add_health_label()
	
func _set_health(health):
	self.health = health
	_update_health_label()
		
func take_damage(amount: int):
	print_debug(name() + ' ' + id + ' took ' + str(amount) + ' damage')
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	_set_health(new_health)
	
func _add_health_label():
	health_label = Label.new()
	health_label.text = str(health)
	health_label.modulate = Color.BLACK
	health_label.anchor_left = 1.0
	health_label.anchor_top = 0.0
	health_label.anchor_right = 1.0
	health_label.anchor_bottom = 0.0
	health_label.offset_left = -30
	health_label.offset_top = 5

	add_child(health_label)

func _on_data_set():
	health = data.max_health
	if health_label:
		_update_health_label()
		
func _update_health_label():
	health_label.text = str(health)
