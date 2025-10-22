class_name PassiveEffect
extends Effect

@export var trigger_strategy: TriggerStrategy
@export var once_per_turn: bool = false

var _fired_this_turn: bool = false
