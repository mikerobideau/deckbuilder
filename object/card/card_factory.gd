class_name CardFactory
extends RefCounted

var BaseCardScene = preload("res://object/card/base_card.tscn")
var Plant = preload("res://object/plant/plant.gd")
var Card = preload("res://object/card/card.gd")

func create_card(data: CardData) -> Card:
	var scene = BaseCardScene.instantiate()
	scene.set_script(Card)
	scene.data = data
	return scene as Card

func create_plant(data: PlantData) -> Plant:
	var scene = BaseCardScene.instantiate()
	scene.set_script(Plant)
	scene.data = data
	return scene as Plant
	
