class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/hero/block.tres")
	]
	
func all_cards() -> Array[BaseCardData]:
	var typed: Array[BaseCardData] = []
	for e in all():
		typed.append(e as BaseCardData)
	return typed

func all_heros() -> Array[HeroData]:
	var result: Array[HeroData] = []
	for item in items:
		if item is HeroData:
			result.append(item)
	return result

func all_items() -> Array[ItemData]:
	var result: Array[ItemData] = []
	for item in items:
		if item is ItemData:
			result.append(item)
	return result
