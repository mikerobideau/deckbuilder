class_name CardFactory
extends RefCounted

var BaseCardScene = preload("res://object/card/base_card.tscn")

func create(data: BaseCardData) -> BaseCard:
	var scene = BaseCardScene.instantiate()
	
	if data is PlantData:
		scene.set_script(preload("res://object/plant/plant.gd"))
	elif data is EventData:
		scene.set_script(preload("res://object/event/event.gd"))
	else:
		scene.set_script(preload("res://object/card/card.gd"))
	
	scene.data = data
	scene.id = _id(data)
	return scene as BaseCard

func _id(data: BaseCardData) -> StringName:
	var type_name = data.get_class().to_lower()
	return StringName("%s_%d" % [type_name, Time.get_unix_time_from_system()])
