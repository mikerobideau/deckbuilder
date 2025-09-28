class_name Card 
extends BaseCard

signal card_clicked(card: Card)
signal card_dragged(card: Card)
signal card_released(card: Card)

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
	
func set_selected(value: bool):
	if selected == value:
		return
	selected = value
	_update_visual_state(true)

func set_base_position(pos: Vector2):
	base_position = pos
	if not dragging:
		_update_visual_state(true)

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
