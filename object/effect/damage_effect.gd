class_name DamageEffect
extends Effect

@export var amount = 1

func apply(target_card: BaseCard, context: EffectContext) -> void:
	if target_card.has_method('take_damage'):
		target_card.take_damage(amount)
