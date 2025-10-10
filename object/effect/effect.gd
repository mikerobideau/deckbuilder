class_name Effect
extends Resource

@export var targeting_strategy: TargetingStrategy
@export var trigger_strategy: TriggerStrategy

func apply(context: EffectContext, source: BaseCard):
	pass

func get_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return targeting_strategy.select_targets(context, source)
