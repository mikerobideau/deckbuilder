class_name Plant
extends Panel

@onready var card_name = $MarginContainer/Name
@onready var style = StyleBoxFlat.new()

@export var data: PlantData:
	set(value):
		_data = value
		if is_node_ready():
			_on_data_set()
	get:
		return _data

var _data: PlantData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func name():
	if !data:
		push_error('Plant - Tried to print name, but data is missing')
	return data.name

func _on_data_set() -> void:
	if _data:
		card_name.text = _data.name
	else:
		card_name.text = ""
