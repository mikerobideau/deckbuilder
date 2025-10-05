class_name BaseCard
extends Panel

signal card_clicked(card: Card)
signal card_dragged(card: Card)
signal card_released(card: Card)

enum CardLocation { HAND, GARDEN }

@onready var card_name = $MarginContainer/Name

@export var id: String
@export var data: BaseCardData:
	set(value):
		_data = value
		if is_node_ready():
			_update_card_name()
			_on_data_set()
	get:
		return _data

var _data: BaseCardData
#TODO: Should this be stateful?  It has a risk of becoming stale
var location: CardLocation
var style: StyleBoxFlat
var selected := false : set = set_selected
var selected_offset = -100
var original_position: Vector2
var base_position: Vector2
var drag_offset: Vector2
var dragging = false
var drag_threshold = 10
var drag_start: Vector2
var _press_mouse: Vector2
var _pressed := false

func _ready() -> void:
	_setup()
	original_position = position
	mouse_filter = Control.MOUSE_FILTER_PASS

func _process(delta: float) -> void:
	pass

func _setup():
	_draw_card()
	_configure_card()
	_update_card_name()
	_on_data_set()
	
func _draw_card():
	style = StyleBoxFlat.new()
	style.bg_color = Const.DEFAULT_COLOR
	style.border_color = Color.BLACK
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_width_left = 3
	style.border_width_right = 3
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	add_theme_stylebox_override("panel", style)
	
func _configure_card():
	pivot_offset = Vector2(size.x / 2, size.y)	

func name():
	return data.name

func _on_data_set() -> void:
	pass
	
func _update_card_name():
	if _data:
		card_name.text = _data.name
		return
	if card_name != null:
		card_name.text = ""
		
func raise():
	var parent = get_parent()
	if parent:
		parent.move_child(self, -1)
		
func pulse():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), Const.ANIMATION_STEP * 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(self, "scale", Vector2(1, 1), Const.ANIMATION_STEP * 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func effect_active():
	return data.effect != null

func apply(context: EffectContext):
	if effect_active():
		pulse()
		data.effect.apply(context, self)
	
func set_selected(value: bool):
	print_debug('setting selected to ' + str(value))
	if selected == value:
		return
	selected = value
	_raise_or_lower(true)

func set_base_position(pos: Vector2):
	base_position = pos
	if not dragging:
		_raise_or_lower(true)

func _raise_or_lower(animated := false):
	print_debug('raising/lowering')
	var target = base_position
	if selected:
		target.y += selected_offset
	if not dragging:
		if animated:
			var tween = create_tween()
			tween.tween_property(self, "position", target, 0.2)\
				.set_trans(Tween.TRANS_SINE)\
				.set_ease(Tween.EASE_OUT)
		else:
			position = target

func _gui_input(event) -> void:
	if is_location_hand():
		_handle_card_in_hand(event)
	_on_card_event(event)
		
func _on_card_event(event) -> void:
	pass
	
func _handle_card_in_hand(event) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_press_mouse = get_viewport().get_mouse_position()
			_pressed = true
		else:
			if not _pressed:
				return
			var now_mouse = get_viewport().get_mouse_position()
			if dragging:
				dragging = false
				emit_signal("card_released", self)
				_raise_or_lower(true)
			else:
				if now_mouse.distance_to(_press_mouse) <= drag_threshold:
					emit_signal("card_clicked", self)
			_pressed = false

	elif event is InputEventMouseMotion and _pressed:
		var now_mouse = get_viewport().get_mouse_position()
		if not dragging and now_mouse.distance_to(_press_mouse) > drag_threshold:
			dragging = true
			raise()
			emit_signal("card_dragged", self)
		if dragging:
			position += event.relative

func set_location_to_hand() -> void:
	location = CardLocation.HAND
	
func is_location_hand() -> bool:
	return location == CardLocation.HAND
	
func set_location_to_garden() -> void:
	location = CardLocation.GARDEN

func is_location_garden() -> bool:
	return location == CardLocation.GARDEN
