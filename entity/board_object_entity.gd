class_name BoardObjectEntity extends Entity

var vault = preload("res://resource/board_object/vault.tres")

func _init():
	items = [
		vault
	]
	
func get_vault():
	return vault
	
func all_board_objects() -> Array[BoardObjectData]:
	var typed: Array[BoardObjectData] = []
	for e in all():
		typed.append(e as BoardObjectData)
	return typed
