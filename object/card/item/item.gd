class_name Item 
extends BaseCard

@onready var icon = $Icon
@onready var name_plate = $NamePlate

func apply(context: EffectContext):
	if effect_active():
		#var t1 = await dissolve()
		await data.effect.apply(context, self)

# ----Visuals ----

func animate_place(position: Vector2):
	var offset = Vector2(0, size.y / 2)
	tilt(0)
	await Animate.move(self, position + offset).finished
	
func _setup_card():
	if _data:
		icon.set_texture(data.img)
		name_plate.set_item_name(data.name)
