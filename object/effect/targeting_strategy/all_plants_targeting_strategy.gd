class_name AllHerosTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return context.heros
