class_name RandomEnemyTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var enemies = context.enemies
	if enemies.size() == 0:
		return []
	var random = RandomUtil.random_choice(enemies)
	return [random]
