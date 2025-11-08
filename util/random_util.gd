class_name RandomUtil
extends RefCounted

static func random_choice(array: Array):
	return array[randi() % array.size()]
