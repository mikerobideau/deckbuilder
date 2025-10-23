class_name CardEntity extends Entity

func _init():
	items = [
		preload("res://resource/hero/tank.tres"),
		
		preload("res://resource/item/heart.tres"),
		preload("res://resource/item/sword.tres"),
		preload("res://resource/item/money_bag.tres"),
		preload("res://resource/item/sleep.tres")
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
