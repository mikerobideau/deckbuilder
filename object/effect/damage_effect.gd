class_name DamageEffect
extends Effect

@export var amount = 1

func apply(context: EffectContext, source: BaseCard) -> void:
	#if there are no heros, damage effect will target base health regardless of targeting strategy
	if context.heros.size() == 0:
		context.base_health.take_damage(amount)
		return
	
	#TODO: Handle case when no enemies
	
	for target in get_targets(context, source):
		if target.has_method('take_damage'):
			var boost = source.tags.get_damage_boost()
			print_debug(boost)
			target.take_damage(amount + boost)
