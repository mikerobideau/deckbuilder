class_name EventSlot
extends Panel

var event: Event

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(175, 250)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color.GRAY
	stylebox.corner_radius_top_left = 16
	stylebox.corner_radius_top_right = 16
	stylebox.corner_radius_bottom_left = 16
	stylebox.corner_radius_bottom_right = 16
	add_theme_stylebox_override("panel", stylebox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_empty() -> bool:
	return event == null
	
func add_event(event: Event) -> void:
	if not is_empty():
		push_warning('Event - Tried to add event, but slot is already occupied')
		return
	self.event = event
	event.position = Vector2.ZERO
	add_child(event)
