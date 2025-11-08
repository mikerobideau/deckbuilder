class_name EnemyEntity extends Entity

func _init():
	items = [
		preload("res://resource/enemy/orc.tres"),
		preload("res://resource/enemy/guard.tres"),
	]
	
func all_enemies() -> Array[EnemyData]:
	var typed: Array[EnemyData] = []
	for e in all():
		typed.append(e as EnemyData)
	return typed
