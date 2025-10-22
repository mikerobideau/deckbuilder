class_name ActiveEffect
extends Effect

@export var energy: ItemData.EnergyType
@export var cooldown_turns: int = 0

var _cooldown: int = 0

func can_fire() -> bool:
	return _cooldown <= 0

func start_cooldown() -> void:
	_cooldown = cooldown_turns

func on_turn_tick() -> void:
	if _cooldown > 0:
		_cooldown -= 1
