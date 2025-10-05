class_name GardenBed
extends Panel

signal garden_bed_selected(bed: GardenBed)

@export var bed_index: int

var plant: Plant = null
var is_selected: bool = false
var stylebox: StyleBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(175, 250)
	stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Const.DEFAULT_BED_COLOR
	stylebox.corner_radius_top_left = 16
	stylebox.corner_radius_top_right = 16
	stylebox.corner_radius_bottom_left = 16
	stylebox.corner_radius_bottom_right = 16
	add_theme_stylebox_override("panel", stylebox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_empty() -> bool:
	return plant == null
	
func add_plant(plant: Plant) -> void:
	if not is_empty():
		push_warning('Garden Bed - Tried to add plant, but bed is already occupied')
		return
	self.plant = plant
	plant.position = Vector2.ZERO
	add_child(plant)
	
func set_selected(selected: bool) -> void:
	is_selected = selected
	_update_visual()
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print_debug('Garden bed selected')
		garden_bed_selected.emit(self)
		
func _update_visual() -> void:
	if is_selected:
		stylebox.bg_color = Const.HIGHLIGHT_COLOR
	else:
		stylebox.bg_color = Const.DEFAULT_BED_COLOR
