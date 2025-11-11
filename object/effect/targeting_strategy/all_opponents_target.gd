class_name AllOpponentsTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return get_opponents(context, source)
