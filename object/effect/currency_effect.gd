class_name CurrencyEffect
extends Effect

@export var amount = 1

func apply(context: EffectContext, source: BaseCard) -> void:
	if !trigger_strategy or trigger_strategy.check(context, source):
		context.currency.add(amount)
