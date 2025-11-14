class_name RandomOpponentTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var opponents = get_opponents(context, source)
	var random: UnitCard = RandomUtil.random_choice(opponents)
	var result: Array[UnitCard] = []
	if random:
		result.append(random)
	return result
