class_name DamageResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData):
	for target in targets:
		if animation:
			animation.play(source)
		await target.take_damage(amount)
