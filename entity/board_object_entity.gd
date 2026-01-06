class_name BoardObjectEntity extends Entity

func _init():
	items = []
	
func all_board_objects() -> Array[BoardObjectData]:
	var typed: Array[BoardObjectData] = []
	for e in all():
		typed.append(e as BoardObjectData)
	return typed
