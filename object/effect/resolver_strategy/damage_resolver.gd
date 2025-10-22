class_name DamageResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard]) -> void:
	for target in targets:
		target.take_damage(amount)
