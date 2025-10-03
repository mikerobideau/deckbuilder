class_name BaseCard
extends Panel

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
var DEFAULT_COLOR = Color.WHITE
var HIGHLIGHT_COLOR = Color(1.0, 0.9, 0.2, 1.0)
var style: StyleBoxFlat

func _ready() -> void:
	_setup()

func _process(delta: float) -> void:
	pass

func _setup():
	_draw_card()
	_configure_card()
	_update_card_name()
	_on_data_set()
	
func _draw_card():
	style = StyleBoxFlat.new()
	style.bg_color = DEFAULT_COLOR
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

func _on_gui_input(event: InputEvent) -> void:
	pass
