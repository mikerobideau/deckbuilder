class_name Health
extends MarginContainer

signal base_health_depleted()

@onready var label = $Label

var health: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health(new_health: int):
	health = new_health
	label.text = 'HEALTH: ' + str(health)

func take_damage(amount: int):
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	set_health(new_health)
	if new_health == 0:
		base_health_depleted.emit()
