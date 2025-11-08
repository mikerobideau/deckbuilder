class_name RandomHeroTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	if context.heroes.size() == 0:
		return []
	var random = RandomUtil.random_choice(context.heroes)
	return [random]
