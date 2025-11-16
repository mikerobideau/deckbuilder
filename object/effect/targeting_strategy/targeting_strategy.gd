class_name TargetingStrategy
extends Resource

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return []

func get_allies(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var allies = []
	if source is Enemy:
		return exclude_source(context.enemies, source)
	if source is Hero or source is Item:
		return exclude_source(context.heroes, source)
	return allies

func get_opponents(context: EffectContext, source: BaseCard):
	print_debug('Getting opponents')
	if source is Enemy:
		return context.heroes
	if source is Hero or source is Item:
		return context.enemies
		
func exclude_source(cards: Array[UnitCard], source: BaseCard) -> Array[UnitCard]:
	var result: Array[UnitCard] = []
	for card in cards:
		if card != source:
			result.append(card)
	return result

func _random_or_empty(units: Array[UnitCard]):
	var random: UnitCard = RandomUtil.random_choice(units)
	var result: Array[UnitCard] = []
	if random:
		result.append(random)
	return result
