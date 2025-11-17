class_name InputUtil
extends Object

static func is_left_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_LEFT \
		and event.pressed

static func is_right_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_RIGHT \
		and event.pressed

static func is_middle_click_down(event: InputEvent) -> bool:
	return event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_MIDDLE \
		and event.pressed

static func is_scroll_up(event: InputEvent) -> bool:
	return event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_UP \
		and event.pressed

static func is_scroll_down(event: InputEvent) -> bool:
	return event is InputEventMouseButton \
		and event.button_index == MOUSE_BUTTON_WHEEL_DOWN \
		and event.pressed
