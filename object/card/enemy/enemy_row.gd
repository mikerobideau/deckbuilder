class_name EnemyRow
extends MarginContainer

@onready var slots: Array = $Slots.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func find_available_slot() -> EnemySlot:
	for slot in slots:
		if slot.is_empty():
			return slot
	return null

func add_enemy(enemy: Enemy):
	var slot = find_available_slot()
	if !slot:
		push_warning('Enemy row row: Tried to add enemy, but there is no available slot.')
	else:
		slot.add_enemy(enemy)

func get_enemies() -> Array[Enemy]:
	var enemies: Array[Enemy] = []
	for slot in slots:
		enemies.append(slot.enemy)
	return enemies

func remove_enemies(enemy: Enemy):
	for slot in slots:
		if !slot.is_empty() and slot.enemy.id == enemy.id:
			slot.clear()
			
func remove_enemy(enemy: Enemy):
	for slot in slots:
		if slot.enemy == enemy:
			slot.enemy = null
	
