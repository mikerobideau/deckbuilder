class_name Enemy
extends UnitCard

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait

func _ready():
	_configure()
	_update_card_appearance()
	
func _configure():
	pivot_offset = size / 2

func apply(context: EffectContext):
	if effect_active():
		pulse()
		var choices = data.effects
		var active_effect = choices[rng.randi_range(0, choices.size() - 1)]
		active_effect.apply(context, self)

func _update_card_appearance():
	if _data:
		if portrait:
			portrait.set_texture(data.img)
		if name_plate:
			name_plate.set_enemy_name(data.name)
