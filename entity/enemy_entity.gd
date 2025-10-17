class_name EnemyEntity extends Entity

func _init():
	items = [
		preload("res://resource/enemy/guard.tres"),
		#preload("res://resource/enemy/ooze.tres"),
		preload("res://resource/enemy/darkness.tres"),
	]
	
func all_enemies() -> Array[EnemyData]:
	var typed: Array[EnemyData] = []
	for e in all():
		typed.append(e as EnemyData)
	return typed
