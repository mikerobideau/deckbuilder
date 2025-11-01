class_name Hero
extends UnitCard

enum HeroClass { SUPPORT, TANK, DAMAGE }

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait

func _ready():
	print_debug('Hero card ready')
	_update_card_appearance()
	_configure()
	
func _configure():
	pivot_offset = size / 2

func _update_card_appearance():
	if _data:
		portrait.set_texture(data.img)
		name_plate.set_hero_name(data.name)
		name_plate.set_hero_class(HeroClass.keys()[data.hero_class])
