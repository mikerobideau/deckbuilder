class_name DamageEffect
extends Effect

@export var amount = 1

func apply(card: BaseCard):
	if card.has_method('take_damage'):
		card.take_damage(amount)
