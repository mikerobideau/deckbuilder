class_name RandomAllyTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var allies = get_allies(context, source)
	return _random_or_empty(allies)
