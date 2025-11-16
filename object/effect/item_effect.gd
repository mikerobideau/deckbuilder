class_name ItemEffect
extends Resource

@export var targeting_strategy: TargetingStrategy
@export var resolver_strategy: ResolverStrategy

func apply(context: EffectContext, source: BaseCard, target_type: ItemData.TargetType) -> Event:
	print_debug('applying item effect')
	var targets = get_targets(context, source)
	var event: Event
	
	var single_target
	if targets.size() == 1:
		single_target = targets[0]

	var target_can_receive_effect = (single_target is Hero and target_type == ItemData.TargetType.HERO) \
		or (single_target is Enemy and target_type == ItemData.TargetType.ENEMY)
	
	if resolver_strategy:
		if target_can_receive_effect or target_type == ItemData.TargetType.NONE:
			event = await resolver_strategy.apply(context, source, targets, null)	
		
	if source.data.energy != ItemData.EnergyType.NONE:	
		if single_target and single_target is Hero:
			print_debug('single target and target is hero')
			#TODO: This implies that hero ability event takes priority over item resolver event
			#This function could return an array, if we need a case where the item and 
			#hero are both triggered, but for now the assumption is that items do not
			#both have a primary ability and trigger the hero card - it's one or the other 
			event = await single_target.trigger_ability(source.data.energy, context, source)

	return event

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	if source.data.target_type != ItemData.TargetType.NONE:
		return targeting_strategy.select_targets(context, source)
	else:
		return []
