class_name DamageResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard]):
	for target in targets:
		await target.take_damage(amount)
