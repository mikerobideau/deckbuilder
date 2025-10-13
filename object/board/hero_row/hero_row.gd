class_name HeroRow
extends Control

@onready var slots: Array = $Slots.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func find_available_slot() -> HeroSlot:
	for slot in slots:
		if slot.is_empty():
			return slot
	return null

func add_hero(hero: Hero):
	var slot = find_available_slot()
	if !slot:
		push_warning('Garden: Tried to add hero, but there is no available slot.')
	else:
		slot.add_hero(hero)
		
func remove_hero(hero: Hero):
	for slot in slots:
		if !slot.is_empty() and slot.hero.id == hero.id:
			slot.clear()
		
func get_heros() -> Array[Hero]:
	var heros: Array[Hero] = []
	for slot in slots:
		heros.append(slot.hero)
	return heros

func apply_all(context: EffectContext):
	for slot in slots:
		if !slot.is_empty():
			slot.hero.apply(context)
			await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
