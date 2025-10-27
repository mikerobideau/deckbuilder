class_name AbilityIndicatorDemo 
extends Control

@onready var yellow = $Abilities/YellowAbility
@onready var green = $Abilities/GreenAbility
@onready var purple = $Abilities/PurpleAbility

func _ready() -> void:
	await Animate.delay(1)
	await yellow.on_for(3)
	await green.on_for(3)
	await purple.on_for(3)
	
func _process(delta: float) -> void:
	pass
