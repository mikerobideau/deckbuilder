class_name ItemEffect
extends Resource

@export var targeting_strategy: TargetingStrategy
@export var resolver_strategy: ResolverStrategy

func apply(context: EffectContext, source: BaseCard, target_type: ItemData.TargetType):
	var targets = get_targets(context, source)
	
	var single_target
	if targets.size() == 1:
		single_target = targets[0]

	var target_can_receive_effect = (single_target is Hero and target_type == ItemData.TargetType.HERO) \
		or (single_target is Enemy and target_type == ItemData.TargetType.ENEMY)
	
	if target_can_receive_effect or target_type == ItemData.TargetType.NONE:
		await resolver_strategy.apply(context, source, targets, null)	
		
	if single_target and single_target is Hero:
		await single_target.trigger_ability(source.data.energy, context, source)

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	if source.data.target_type != ItemData.TargetType.NONE:
		return targeting_strategy.select_targets(context, source)
	else:
		return []
