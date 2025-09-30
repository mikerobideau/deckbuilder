class_name HealEffect
extends Effect

@export var amount = 1

func apply(card: BaseCard):
	if card.has_method('heal'):
		card.heal(amount)
