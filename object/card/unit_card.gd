class_name UnitCard
extends BaseCard

signal unit_card_targeted(card: UnitCard)
signal unit_card_health_depleted(card: UnitCard)

@export var health: int

var health_label: Label
var is_selected: bool = false
		
func _ready():
	_setup()
	_add_health_label()
	mouse_filter = Control.MOUSE_FILTER_PASS
	
func _set_health(health):
	self.health = health
	_update_health_label()
		
func take_damage(amount: int):
	var new_health = health - amount
	if new_health < 0:
		new_health = 0
	_set_health(new_health)
	if new_health == 0:
		unit_card_health_depleted.emit(self)
	
func heal(amount: int):
	var new_health = health + amount
	if new_health > data.max_health:
		new_health = data.max_health
	_set_health(new_health)
	
func _add_health_label():
	health_label = Label.new()
	health_label.text = str(health)
	health_label.modulate = Color.BLACK
	health_label.anchor_left = 1.0
	health_label.anchor_top = 0.0
	health_label.anchor_right = 1.0
	health_label.anchor_bottom = 0.0
	health_label.offset_left = -30
	health_label.offset_top = 5
	add_child(health_label)

func _on_data_set():
	health = data.max_health
	if health_label:
		_update_health_label()
		
func _update_health_label():
	health_label.text = str(health)
	
func _on_card_event(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_location_board():
			unit_card_targeted.emit(self)

func set_highlighted(is_highlighted: bool) -> void:
	if is_highlighted:
		style.bg_color = Const.HIGHLIGHT_COLOR
	else:
		style.bg_color = Const.DEFAULT_COLOR
