class_name Hero
extends UnitCard

enum HeroClass { SUPPORT, TANK, DAMAGE }

@onready var name_plate = $NamePlate
@onready var portrait = $Portrait
@onready var mana_cost = $ManaCost

func _ready():
	_setup_card()
	_configure()
	_paint()
	_connect_signals()
	
func _configure():
	pivot_offset = size / 2
	scale = Const.CARD_SCALE_DEFAULT	

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
		mana_cost.text = str(data.mana_cost)
		_set_health(_data.max_health)

func trigger_ability(energy: ItemData.EnergyType, context: EffectContext, source: BaseCard) -> Event:
	var ability = _find_ability(energy)
	var event: Event
	if ability and !is_disabled:
		event = await ability.apply(context, self)
	return event

func _find_ability(energy: ItemData.EnergyType):
	for ability in data.abilities:
		if ability.energy == energy:
			return ability
	return null

func react(event: Event, context: EffectContext):
	var reaction = data.reaction
	if reaction and _should_react(event, reaction.condition):
		await reaction.apply(context, self)
	
func _should_react(event: Event, condition: Event):
	return event.effect_type == condition.effect_type and (!condition.amount or event.amount >= condition.amount)
