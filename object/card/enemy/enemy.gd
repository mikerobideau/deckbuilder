class_name Enemy
extends UnitCard

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait

func _ready():
	_configure()
	_setup_card()
	_connect_signals()
	
func _configure():
	pivot_offset = size / 2

func apply(context: EffectContext):
	if effect_active():
		var active_effect = RandomUtil.random_choice(data.effects)
		#print_debug('active effect is '  + active_effect.name)
		active_effect.apply(context, self)

func _setup_card():
	if _data:
		portrait.set_texture(_data.img)
		name_plate.set_enemy_name(_data.name)
		_set_health(_data.max_health)
