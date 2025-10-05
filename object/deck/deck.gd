extends Node
class_name Deck

@export var sunflower_seed_path: String = "res://resource/card/sunflower_seed.tres"
@export var sunflower_path: String = "res://resource/plant/sunflower.tres"
@export var soil_path: String = "res://resource/card/soil.tres"
@export var water_path: String = "res://resource/card/water.tres"
@export var sun_path: String = "res://resource/card/sun.tres"

signal card_drawn(card: BaseCardData)

var cards: Array[BaseCardData] = []
var discard_pile: Array[BaseCardData] = []

func _ready():
	var sunflower_seed_card = load(sunflower_seed_path) as BaseCardData
	var sunflower_card = load(sunflower_path) as BaseCardData
	var soil_card = load(soil_path) as BaseCardData
	var water_card = load(water_path) as BaseCardData
	var sun_card = load(sun_path) as BaseCardData
	
	cards.clear()
	cards.append_array(repeat_card(sunflower_seed_card, 3))
	cards.append_array(repeat_card(sunflower_card, 10))
	cards.append_array(repeat_card(soil_card, 3))
	cards.append_array(repeat_card(water_card, 3))
	cards.append_array(repeat_card(sun_card, 3))
	shuffle()

func repeat_card(card: BaseCardData, times: int) -> Array[BaseCardData]:
	var arr: Array[BaseCardData] = []
	for i in times:
		arr.append(card)
	return arr

func shuffle():
	cards.shuffle()

func draw():
	if is_empty():
		replenish()
	if is_empty():
		return null # deck and discard pile are empty
	var card = cards.pop_back()
	card_drawn.emit(card)
	return card

func discard(card: BaseCardData):
	discard_pile.append(card)

func replenish():
	cards.append_array(discard_pile)
	discard_pile.clear()
	shuffle()
	
func is_empty():
	return cards.size() == 0
