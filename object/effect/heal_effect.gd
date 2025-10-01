class_name HealEffect
extends Effect

@export var amount = 1

func apply(target_card: BaseCard, context: EffectContext) -> void:
	if target_card.has_method('heal'):
		target_card.heal(amount)
