class_name EventRow
extends Control

@onready var slots: Array = $Slots.get_children()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func find_available_slot() -> EventSlot:
	for slot in slots:
		if slot.is_empty():
			return slot
	return null

func add_event(event: Event):
	var slot = find_available_slot()
	if !slot:
		push_warning('Event row: Tried to add event, but there is no available slot.')
	else:
		slot.add_event(event)

func apply_all(context: EffectContext):
	for slot in slots:
		if !slot.is_empty():
			slot.event.apply(context)
			await get_tree().create_timer(Const.ANIMATION_DELAY).timeout

func get_events() -> Array[Event]:
	var events: Array[Event] = []
	for slot in slots:
		events.append(slot.event)
	return events
