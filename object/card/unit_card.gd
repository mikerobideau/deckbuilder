class_name UnitCard
extends BaseCard

signal unit_card_targeted(card: UnitCard)
signal unit_card_health_depleted(card: UnitCard)

@export var health: int

@onready var health_container = $ContentContainer/Content/BottomContainer/BottomContent/HealthContainer

var health_label: Label
var is_selected: bool = false
var rng: RandomNumberGenerator
		
func _ready():
	_setup()
	_add_health_label()
	mouse_filter = Control.MOUSE_FILTER_PASS
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng
		
# ---- Effects ----
	
func _set_health(health):
	self.health = health
	_update_health_label()

		
func trigger_ability(energy: ItemData.EnergyType, context: EffectContext, source: BaseCard):
	var ability = _find_ability(energy)
	if ability:
		ability.apply(context, self)
		
func take_damage(amount: int):
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	_set_health(new_health)
	if new_health == 0:
		unit_card_health_depleted.emit(self)
	
func heal(amount: int):
	if tags.has_antiheal():
		return
	var new_health = health + amount
	if new_health > data.max_health:
		new_health = data.max_health
	_set_health(new_health)
	
func _add_health_label():
	health_label = Label.new()
	health_label.text = str(health)
	health_label.modulate = Color.WHITE
	health_label.anchor_left = 0.0
	health_label.anchor_top = 0.0
	health_label.anchor_right = 0.0
	health_label.anchor_bottom = 0.0
	health_label.offset_left = 5
	health_label.offset_top = 5

	var font = ThemeDB.fallback_font
	health_label.add_theme_font_size_override("font_size", 18)

	var style = StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.4, 0.7)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	health_label.add_theme_stylebox_override("normal", style)

	health_container.add_child(health_label)

func _on_data_set():
	health = data.max_health
	if health_label:
		_update_health_label()
		
func _update_health_label():
	health_label.text = str(health)
	
func _on_card_event(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		if is_location_board():
			unit_card_targeted.emit(self)
	
func effect_active():
	return !is_disabled
	
func _find_ability(energy: ItemData.EnergyType):
	for ability in data.abilities:
		if ability.energy == energy:
			return ability
	return null
