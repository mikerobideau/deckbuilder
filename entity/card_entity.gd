class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/card/water.tres")
	]
	
func all_cards() -> Array[CardData]:
	var typed: Array[CardData] = []
	for e in all():
		typed.append(e as CardData)
	return typed
