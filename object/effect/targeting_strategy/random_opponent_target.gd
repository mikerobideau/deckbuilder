class_name RandomOpponentTarget
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var opponents = get_opponents(context, source)
	print_debug('Found ' + str(opponents.size()) + ' opponents')
	var random = RandomUtil.random_choice(opponents)
	print_debug('found random opponent ' + random.name())
	return [random]
