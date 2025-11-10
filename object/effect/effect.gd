class_name Effect
extends Resource

@export var name: String
@export var targeting_strategy: TargetingStrategy
@export var resolver_strategy: ResolverStrategy
@export var animation: AnimationData

func apply(context: EffectContext, source: BaseCard):
	var targets = get_targets(context, source)
	await resolver_strategy.apply(context, source, targets, animation)

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return targeting_strategy.select_targets(context, source)
