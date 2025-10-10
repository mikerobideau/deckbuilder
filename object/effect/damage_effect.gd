class_name DamageEffect
extends Effect

@export var amount = 1

func apply(context: EffectContext, source: BaseCard) -> void:
	#if there are no plants, damage effect will target base health regardless of targeting strategy
	if context.plants.size() == 0:
		context.base_health.take_damage(amount)
		return
	
	for target in get_targets(context, source):
		if target.has_method('take_damage'):
			target.take_damage(amount)
