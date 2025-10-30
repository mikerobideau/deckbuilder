class_name Item 
extends BaseCard

func apply(context: EffectContext):
	if effect_active():
		await dissolve()
		data.effect.apply(context, self)

# ----Visuals ----

func animate_place(position: Vector2):
	var offset = Vector2(0, size.y / 2)
	var duration = Const.ANIMATION_STEP / 2
	tilt(0, duration)
	await move(position + offset, duration)
