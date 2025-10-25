class_name BaseCard
extends Panel

signal card_selected(card: Item)
signal card_clicked(card: Item)
signal card_dragged(card: Item)
signal card_released(card: Item)

enum CardLocation { HAND, BOARD }
enum Rarity { COMMON, UNCOMMON, RARE, LEGENDARY }

@onready var card_name = $ContentContainer/Content/NameContainer/Name
@onready var description = $ContentContainer/Content/BottomContainer/BottomContent/Description
@onready var tags = $ContentContainer/Content/BottomContainer/BottomContent/Tags
@onready var highlight_fx = $HighlightFx

const HighlightShader = preload("res://shader/highlight_shader.gdshader")

@export var id: String
@export var data: BaseCardData:
	set(value):
		_data = value
		if is_node_ready():
			_update_card_appearance()
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
var _highlight_mat: ShaderMaterial = null

func _ready() -> void:
	_setup()
	original_position = position
	mouse_filter = Control.MOUSE_FILTER_PASS

func _process(delta: float) -> void:
	pass

func _setup():
	_draw_card()
	_configure_card()
	_update_card_appearance()
	_on_data_set()
	_connect_signals()
	
func _draw_card():
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
	
func _configure_card():
	pivot_offset = Vector2(size.x / 2, size.y)	

func name():
	return data.name

func _on_data_set() -> void:
	pass
	
func _update_card_appearance():
	if _data:
		card_name.text = _data.name
		description.text = _data.description
		return
	if card_name != null:
		card_name.text = ""
		
func _connect_signals():
	tags.tag_expired.connect(_on_tag_expired)
		
func raise():
	var parent = get_parent()
	if parent:
		parent.move_child(self, -1)
		
func pulse():
	var tween = create_tween()
	await tween.tween_property(self, "scale", Vector2(1.2, 1.2), Const.ANIMATION_STEP * 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	await tween.tween_property(self, "scale", Vector2(1, 1), Const.ANIMATION_STEP * 0.75).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func effect_active():
	return data.effect != null and !is_disabled

func disable():
	is_disabled = true
	_gray_out_description()

func enable():
	is_disabled = false
	_restore_gray_out_description()
	
func _on_tag_expired(tag: Tag):
	match tag.type:
		Tag.TagType.DISABLED:
			enable()

func _gray_out_description():
	description.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6)) # gray text
	description.add_theme_constant_override("shadow_offset_y", 0)

func _restore_gray_out_description():
	description.add_theme_color_override("font_color", Color(0, 0, 0)) # restore to black

func apply(context: EffectContext):
	if effect_active():
		await pulse()
		data.effect.apply(context, self)

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
	_animate_selection(true)
	card_selected.emit(self)

func select():
	set_selected(true)

func deselect():
	set_selected(false)

func set_base_position(pos: Vector2):
	if !is_location_hand():
		return
	base_position = pos
	if not dragging:
		_animate_selection(true)

func _animate_selection(animated := false):
	if !is_location_hand:
		return
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
			
	set_highlighted(selected)
	
func set_highlighted(is_highlighted: bool) -> void:
	_apply_highlight() if is_highlighted else _remove_highlight()
			
func _apply_highlight():
	#TODO: Only generate this once
	if _highlight_mat == null:
		_highlight_mat = ShaderMaterial.new()
		_highlight_mat.shader = HighlightShader
		_highlight_mat.resource_local_to_scene = true
	highlight_fx.material = _highlight_mat

func _remove_highlight():
	highlight_fx.material = null

func _on_gui_input(event) -> void:
	if is_location_hand():
		_handle_card_in_hand(event)
	_on_card_event(event)
		
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
				_animate_selection(true)
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
