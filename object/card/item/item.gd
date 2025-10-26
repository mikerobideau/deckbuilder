class_name Item 
extends BaseCard

func apply(context: EffectContext):
	if effect_active():
		await dissolve()
		data.effect.apply(context, self)
