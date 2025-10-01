class_name DamageEffect
extends Effect

@export var amount = 1

func apply(context: EffectContext) -> void:
	for target in get_targets(context):
		if target.has_method('take_damage'):
			target.take_damage(amount)
