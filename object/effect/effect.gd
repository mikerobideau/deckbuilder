class_name Effect
extends Resource

@export var targeting_strategy: TargetingStrategy

func apply(context: EffectContext, source: UnitCard):
	pass

func get_targets(context: EffectContext, source: UnitCard) -> Array[UnitCard]:
	return targeting_strategy.select_targets(context, source)
