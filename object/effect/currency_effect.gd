class_name CurrencyEffect
extends Effect

@export var amount = 1

func apply(context: EffectContext, source: BaseCard) -> void:
	context.currency.add(amount)
