class_name AllAlliesTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return get_allies(context, source)
