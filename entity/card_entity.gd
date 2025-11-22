class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/hero/fairy.tres"),
		preload("res://resource/hero/viking.tres"),
		#preload("res://resource/hero/cowboy.tres"),
		#preload("res://resource/hero/pirate.tres"),
		#preload("res://resource/hero/wizard.tres"),
		#preload("res://resource/hero/mech.tres"),
		#preload("res://resource/hero/witch.tres"),
		
		#preload("res://resource/item/heart.tres"),
		#preload("res://resource/item/sword.tres"),
		#preload("res://resource/item/cash.tres"),
		#preload("res://resource/item/sleep.tres"),
		#preload("res://resource/item/cannon.tres"),
		
		preload("res://resource/item/energy/strength.tres"),
		preload("res://resource/item/energy/vitality.tres"),
		#preload("res://resource/item/energy/wisdom.tres"),
		#preload("res://resource/item/energy/fortune.tres"),
		#preload("res://resource/item/energy/magic.tres"),
		#preload("res://resource/item/energy/tech.tres")
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
