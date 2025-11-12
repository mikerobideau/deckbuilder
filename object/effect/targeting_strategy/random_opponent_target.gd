class_name RandomOpponentTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var opponents = get_opponents(context, source)
	var random = RandomUtil.random_choice(opponents)
	return [random]
