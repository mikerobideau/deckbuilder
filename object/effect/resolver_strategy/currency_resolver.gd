class_name CurrencyResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData) -> void:
	await context.currency.add(amount)
