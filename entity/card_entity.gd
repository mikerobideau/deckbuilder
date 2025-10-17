class_name CardEntity extends Entity

func _init():
	items = [
		#preload("res://resource/hero/hacker.tres"),
		preload("res://resource/hero/tank.tres"),
		#preload("res://resource/hero/healer.tres"),
		
		#preload("res://resource/item/heart.tres"),
		#preload("res://resource/item/orb.tres"),
		preload("res://resource/item/sleep.tres"),
		#preload("res://resource/item/damage_boost.tres")
		preload("res://resource/item/antiheal.tres")
	]
	
func all_cards() -> Array[BaseCardData]:
	var typed: Array[BaseCardData] = []
	for e in all():
		typed.append(e as BaseCardData)
	return typed
