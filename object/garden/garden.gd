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
			return bed
	return null

func add_plant(plant: Plant):
	var bed = find_available_bed()
	if !bed:
		push_warning('Garden: Tried to add plant, but there is no available bed.')
	else:
		bed.add_plant(plant)
		
func get_plants() -> Array[Plant]:
	var plants: Array[Plant] = []
	for bed in beds:
		plants.append(bed.plant)
	return plants

func apply_all(context: EffectContext):
	for bed in beds:
		if !bed.is_empty():
			bed.plant.apply(context)
			await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
