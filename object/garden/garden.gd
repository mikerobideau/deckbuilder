class_name Garden
extends Control

@onready var beds: Array = $Beds.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func find_available_bed() -> GardenBed:
	for bed in beds:
		if bed.is_empty():
			print_debug('Garden - found empty bed')
			return bed
	print_debug('Garden - no bed found')
	return null

func add_plant(plant: Plant):
	var bed = find_available_bed()
	if !bed:
		push_warning('Garden: Tried to add plant, but there is no available bed.')
	else:
		print_debug('Garden: Adding plant')
		bed.add_plant(plant)
