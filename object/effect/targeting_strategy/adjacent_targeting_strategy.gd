class_name AdjacentEventTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: UnitCard) -> Array[UnitCard]:
	var index = _find_index(context, source)
	if index > -1:
		var event = null
		if index >= 0 and index < context.events.size():
			event = context.events[index]
			return [event]
		else: 
			return []
	return [] as Array[UnitCard]

func _find_index(context: EffectContext, source: UnitCard):
	var index := -1
	for i in context.plants.size():
		if context.plants[i].id == source.id:
			index = i
	return index
