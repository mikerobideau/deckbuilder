class_name RandomUtil
extends RefCounted

static func random_choice(array: Array):
	if array.size() < 1:
		return null
	return array[randi() % array.size()]
