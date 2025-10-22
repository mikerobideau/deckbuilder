class_name EnemyAcrossTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var index = _find_index(context, source)
	if index > -1:
		var event = null
		if index >= 0 and index < context.enemies.size():
			event = context.enemies[index]
			return [event]
		else: 
			return []
	return [] as Array[UnitCard]

func _find_index(context: EffectContext, source: BaseCard):
	var index := -1
	for i in context.heroes.size():
		if context.heroes[i].id == source.id:
			index = i
	return index
