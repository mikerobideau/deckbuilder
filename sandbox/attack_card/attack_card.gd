class_name AttackCard 
extends Control

@export var duration = Const.ANIMATION_STEP * 1

func _ready() -> void:
	await Animate.delay(1)

func _process(delta: float) -> void:
	pass

func attack(target_position: Vector2):
	var start_position = global_position
	var tween = create_tween()
	tween.tween_property(self, 'global_position', target_position, duration)
	tween.tween_property(self, 'global_position', start_position, duration)
