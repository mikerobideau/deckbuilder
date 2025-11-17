class_name HealResolver
extends ResolverStrategy

@export var amount := 2

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData) -> void:
	for target in targets:
		if animation:
			animation.play(source)
		await target.heal(amount)
