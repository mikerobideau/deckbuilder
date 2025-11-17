class_name SelfTargeting
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return [source]
