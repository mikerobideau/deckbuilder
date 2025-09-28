class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/event/storm.tres"),
	]
	
func all_events() -> Array[EventData]:
	var typed: Array[EventData] = []
	for e in all():
		typed.append(e as EventData)
	return typed
