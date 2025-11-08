class_name Hero
extends UnitCard

enum HeroClass { SUPPORT, TANK, DAMAGE }

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait

func _ready():
	_setup_card()
	_configure()
	_paint()
	_connect_signals()
	
func _configure():
	pivot_offset = size / 2

func _paint():
	portrait.set_outer_color(Const.HERO_PORTRAIT_OUTER_COLOR)
	portrait.set_inner_color(Const.HERO_PORTRAIT_INNER_COLOR)
	portrait.set_background_color(Const.HERO_PORTRAIT_BACKGROUND_COLOR)
	portrait.set_icon_color(Const.HERO_PORTRAIT_ICON_COLOR)
	name_plate.set_name_plate_color(Const.HERO_NAMEPLATE_BACKGROUND_COLOR)
	name_plate.set_name_plate_font_color(Const.HERO_NAMEPLATE_FONT_COLOR)
	name_plate.set_class_plate_color(Const.HERO_CLASS_NAMEPLATE_BACKGROUND_COLOR)
	name_plate.set_class_plate_font_color(Const.HERO_CLASS_NAMEPLATE_FONT_COLOR)

func _setup_card():
	if _data:
		portrait.set_texture(_data.img)
		name_plate.set_hero_name(_data.name)
		name_plate.set_hero_class(HeroClass.keys()[_data.hero_class])
		_set_health(_data.max_health)

func trigger_ability(energy: ItemData.EnergyType, context: EffectContext, source: BaseCard):
	var ability = _find_ability(energy)
	if ability and !is_disabled:
		await ability.apply(context, self)
