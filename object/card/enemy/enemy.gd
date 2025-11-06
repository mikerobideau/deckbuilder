class_name Enemy
extends UnitCard

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait

func _ready():
	_configure()
	_setup_card()
	
func _configure():
	pivot_offset = size / 2

func apply(context: EffectContext):
	if effect_active():
		pulse()
		var choices = data.effects
		var active_effect = choices[rng.randi_range(0, choices.size() - 1)]
		active_effect.apply(context, self)

func _setup_card():
	if _data:
		portrait.set_texture(_data.img)
		name_plate.set_enemy_name(_data.name)
		_set_health(_data.max_health)
