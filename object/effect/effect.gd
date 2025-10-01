class_name Effect
extends Resource

@export var targeting_strategy: TargetingStrategy

func apply(context: EffectContext):
	pass

func get_targets(context: EffectContext) -> Array[UnitCard]:
	return targeting_strategy.select_targets(context)
