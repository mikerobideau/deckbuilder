class_name ItemEffect
extends Resource

@export var targeting_strategy: TargetingStrategy
@export var resolver_strategy: ResolverStrategy

func apply(context: EffectContext, source: BaseCard):
	var targets = get_targets(context, source)
	resolver_strategy.apply(context, source, targets)
	
	for target in targets: 
		if target is Hero:
			target.trigger_ability(source.data.energy, context, source)

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return targeting_strategy.select_targets(context, source)
