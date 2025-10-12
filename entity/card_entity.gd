class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/hero/main_hero.tres"),
		preload("res://resource/card/water.tres")
	]
	
func all_cards() -> Array[BaseCardData]:
	var typed: Array[BaseCardData] = []
	for e in all():
		typed.append(e as BaseCardData)
	return typed
