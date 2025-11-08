class_name BaseCard
extends Panel

signal card_selected(card: Item)
signal card_clicked(card: Item)
signal card_dragged(card: Item)
signal card_released(card: Item)

enum CardLocation { HAND, BOARD }
enum Rarity { COMMON, UNCOMMON, RARE, LEGENDARY }

@onready var card_name = $ContentContainer/Content/NameContainer/Name
@onready var tags = $Tags
@onready var content = $ContentContainer/Content
@onready var highlight_fx = $HighlightFx
@onready var floating_text = $FloatingText
@onready var energy_trail = $EnergyTrail

@export var id: String
@export var data: BaseCardData:
	set(value):
		_data = value
		if is_node_ready():
			_setup_card()
			_on_data_set()
	get:
		return _data

var _data: BaseCardData
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
var hand_input_enabled: bool = false
var is_disabled = false
var strike_through: ColorRect

func _ready() -> void:
	_setup()
	if material:
		material = material.duplicate(true) 
	original_position = position
	mouse_filter = Control.MOUSE_FILTER_PASS

func _process(delta: float) -> void:
	pass

func _setup():
	_configure_card()
	_setup_card()
	_on_data_set()
	_connect_signals()
	_draw_background()
	
func _configure_card():
	pivot_offset = Vector2(size.x / 2, size.y / 2);

func _on_mouse_entered() -> void:
	animate_focus()

func _on_mouse_exited() -> void:
	animate_unfocus()

func _on_gui_input(event) -> void:
	if is_location_hand():
		_handle_card_in_hand(event)
	_on_card_event(event)
		
func _connect_signals():
	print_debug('connecting _on_tag_expired')
	tags.tag_expired.connect(_on_tag_expired)

func _on_data_set() -> void:
	pass

func name():
	return data.name
		
func effect_active():
	return data.effect != null and !is_disabled

func disable():
	is_disabled = true
	#_gray_out_description()

func enable():
	is_disabled = false
	#_restore_gray_out_description()
	
func _on_tag_expired(tag: Tag):
	print_debug('tag expired for ' + name())
	match tag.type:
		Tag.TagType.DISABLED:
			print_debug('enabling')
			enable()

func apply(context: EffectContext):
	if effect_active():
		await data.effect.apply(context, self)
	else:
		print_debug('effect is not active for card ' + name() + ' ' + data.id)

func add_or_update_tag(type: Tag.TagType, amount: int):
	if type == Tag.TagType.DISABLED:
		disable()
	tags.add_or_update_tag(type, amount)
	
func after_turn():
	for tag in tags.get_children():
		if tag.is_tick:
			tag.tick()

func set_selected(value: bool):
	if selected == value:
		return
	selected = value
	set_highlighted(selected)
	_animate_pop_up() if selected else _animate_pop_down()
	card_selected.emit(self)

func select():
	set_selected(true)

func deselect():
	set_selected(false)
		
func _on_card_event(event) -> void:
	pass
	
func _handle_card_in_hand(event) -> void:
	if hand_input_enabled == false:
		return
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
				#set_selected(true)
				#_animate_pop_up()
				#_animate_selection(true)
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
	
func set_location_to_board() -> void:
	location = CardLocation.BOARD
	base_position = Vector2.ZERO
	position = Vector2.ZERO
	rotation = 0

func is_location_board() -> bool:
	return location == CardLocation.BOARD
	
# ---- Visuals ----
	
func dissolve(color = Color.WHITE):
	var tween = create_tween()
	modulate = color
	tween.tween_property(
		material, 
		'shader_parameter/progress',
		3.0,
		0.4
	)
	await Animate.delay(0.1)
	energy_trail.visible = true
	energy_trail.play()
	await Animate.delay(0.4)
	energy_trail.stop()

func raise():
	var parent = get_parent()
	if parent:
		parent.move_child(self, -1)
		
func pulse():
	pass
	#var tween = create_tween()
	#await tween.tween_property(self, "scale", Vector2(1.2, 1.2), Const.ANIMATION_STEP * 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	#await tween.tween_property(self, "scale", Vector2(1, 1), Const.ANIMATION_STEP * 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _animate_pop_up():
	if !is_location_hand:
		return
	var pos = base_position + Vector2(0, selected_offset)
	var tween = create_tween()
	tween.tween_property(self, "position", pos, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
		
func _animate_pop_down():
	if !is_location_hand:
		return
	if selected:
		return
	var tween = create_tween()
	tween.tween_property(self, "position", base_position, 0.2)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
#func _gray_out_description():
#	description.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6)) # gray text
#	description.add_theme_constant_override("shadow_offset_y", 0)

#func _restore_gray_out_description():
#	description.add_theme_color_override("font_color", Color(0, 0, 0)) # restore to black

func set_highlighted(is_highlighted: bool) -> void:
	_apply_highlight() if is_highlighted else _remove_highlight()
			
func _apply_highlight():
	highlight_fx.visible = true

func _remove_highlight():
	highlight_fx.visible = false
	
func _setup_card():
	if _data:
		card_name.text = _data.name
		#description.text = _data.description
		return
	if card_name != null:
		push_warning('Card name is null')
		card_name.text = ""

func _draw_background():
	style = StyleBoxFlat.new()
	style.bg_color = Const.CARD_COLOR
	style.border_color = Color.WHITE
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_width_left = 3
	style.border_width_right = 3
	style.corner_radius_top_left = Const.CARD_RADIUS
	style.corner_radius_top_right = Const.CARD_RADIUS
	style.corner_radius_bottom_left = Const.CARD_RADIUS
	style.corner_radius_bottom_right = Const.CARD_RADIUS
	add_theme_stylebox_override("panel", style)
	
func set_base_position(pos: Vector2):
	if !is_location_hand():
		return
	base_position = pos
	if not dragging:
		_animate_pop_down()
	
func tilt(angle: float, duration = Const.ANIMATION_STEP):
	var tween = create_tween()
	tween.tween_property(self, 'rotation_degrees', angle, duration)
	return tween.finished
	
func animate_scale(amount = 1.0, duration = Const.ANIMATION_STEP / 3):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', Vector2(amount, amount), duration)
	await tween.finished
	
func animate_focus():
	if dragging:
		return
	if location == CardLocation.BOARD:
		Animate.shake(self, 1.0)
	if location == CardLocation.HAND:
		_animate_pop_up()
		raise()
	await animate_scale(1.25)

func animate_unfocus():
	if !selected:
		_animate_pop_down()
		raise()
	await animate_scale(1.0)
