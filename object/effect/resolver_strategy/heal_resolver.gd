class_name HealResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard]) -> void:
	print_debug('Applying heal resolver')
	for target in targets:
		target.heal(amount)
