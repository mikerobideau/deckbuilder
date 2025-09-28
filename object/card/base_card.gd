class_name BaseCard
extends Panel

@onready var card_name = $MarginContainer/Name

@export var data: CardData:
	set(value):
		_data = value
		if is_node_ready():
			_on_data_set()
	get:
		return _data

var _data: CardData

func _ready() -> void:
	_init()

func _init():
	pivot_offset = Vector2(size.x / 2, size.y)
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
	_on_data_set()
	
func _process(delta: float) -> void:
	pass

func name():
	return data.name

func _on_data_set() -> void:
	if _data:
		card_name.text = _data.name
	else:
		card_name.text = ""
		
func raise():
	var parent = get_parent()
	if parent:
		parent.move_child(self, -1)
