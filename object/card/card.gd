class_name Card
extends Panel

signal card_clicked(card: Card)
signal card_dragged(card: Card)
signal card_released(card: Card)

@onready var card_name = $MarginContainer/Name
@onready var style = StyleBoxFlat.new()

@export var data: CardData:
	set(value):
		_data = value
		_on_data_set()
	get:
		return _data

var _data: CardData
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
	original_position = position
	pivot_offset = Vector2(size.x / 2, size.y)
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color.WHITE
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

func set_selected(value: bool):
	if selected == value:
		return
	selected = value
	_update_visual_state(true)

func set_base_position(pos: Vector2):
	base_position = pos
	if not dragging:
		_update_visual_state(true)
		
func _on_data_set() -> void:
	if _data:
		card_name.text = _data.name
	else:
		card_name.text = ""

func _update_visual_state(animated := false):
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
				_update_visual_state(true)
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

func raise():
	var parent = get_parent()
	if parent:
		parent.move_child(self, -1)
