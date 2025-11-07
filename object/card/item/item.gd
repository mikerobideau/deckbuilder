class_name Item 
extends BaseCard

@onready var icon = $Icon
@onready var name_plate = $NamePlate

func apply(context: EffectContext):
	if effect_active():
		await Animate.delay(Const.ANIMATION_STEP / 4)
		animate()
		await Animate.delay(Const.ANIMATION_STEP / 4)
		await data.effect.apply(context, self)

func animate_place(position: Vector2):
	var offset = Vector2(0, size.y - 20)
	tilt(0)
	await Animate.move(self, position + offset)
	
func _setup_card():
	if _data:
		icon.set_texture(data.img)
		name_plate.set_item_name(data.name)

func animate():
	_data.animation.play(self)
