class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/card/water.tres"),
		preload("res://resource/card/sunflower_seed.tres"),
		preload("res://resource/card/sun.tres"),
		preload("res://resource/card/soil.tres"),
		preload("res://resource/card/damage_spell.tres"),
	]
	
func all_cards() -> Array[CardData]:
	var typed: Array[CardData] = []
	for e in all():
		typed.append(e as CardData)
	return typed
