class_name CurrencyResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard]) -> void:
	context.currency.add(amount)
