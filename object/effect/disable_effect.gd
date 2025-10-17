class_name DisableEffect
extends Effect

func apply(context: EffectContext, source: BaseCard) -> void:
	for target in get_targets(context, source):
		if target.has_method('disable'):
			target.disable()
