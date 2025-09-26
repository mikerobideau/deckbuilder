class_name GardenBed
extends Panel

@export var bed_index: int
var plant: Plant = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(175, 250)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.36, 0.25, 0.20) # brown
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
