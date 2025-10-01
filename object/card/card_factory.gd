class_name CardFactory
extends RefCounted

var BaseCardScene = preload("res://object/card/base_card.tscn")
var Plant = preload("res://object/plant/plant.gd")
var Card = preload("res://object/card/card.gd")
var Event = preload("res://object/event/event.gd")

func create_card(data: CardData) -> Card:
	var scene = BaseCardScene.instantiate()
	scene.set_script(Card)
	scene.data = data
	scene.id = id('card')
	return scene as Card

func create_plant(data: PlantData) -> Plant:
	var scene = BaseCardScene.instantiate()
	scene.set_script(Plant)
	scene.data = data
	scene.id = id('plant')
	return scene as Plant
	
func create_event(data: EventData) -> Event:
	var scene = BaseCardScene.instantiate()
	scene.set_script(Event)
	scene.data = data
	scene.id = id('event')
	return scene as Event

func id(type: String):
	return StringName(str(type, Time.get_unix_time_from_system()))
