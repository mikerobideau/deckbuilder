class_name Effect
extends Resource

enum EffectType { DAMAGE, HEAL, MONEY }

@export var name: String
@export var targeting_strategy: TargetingStrategy
@export var resolver_strategy: ResolverStrategy
@export var animation: AnimationData

func apply(context: EffectContext, source: BaseCard) -> Event:
	var targets = get_targets(context, source)
	return await resolver_strategy.apply(context, source, targets, animation)

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	if !targeting_strategy:
		return []
	return targeting_strategy.select_targets(context, source)
