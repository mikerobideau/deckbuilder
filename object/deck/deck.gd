extends Node
class_name Deck

@export var sunflower_seed_path: String = "res://resource/card/sunflower_seed.tres"
@export var soil_path: String = "res://resource/card/soil.tres"
@export var water_path: String = "res://resource/card/water.tres"

signal card_drawn(card: CardData)

var cards: Array[CardData] = []
var discard_pile: Array[CardData] = []

func _ready():
	var sunflower_seed_card = load(sunflower_seed_path) as CardData
	var soil_card = load(soil_path) as CardData
	var water_card = load(water_path) as CardData
	
	cards.clear()
	cards.append_array(repeat_card(sunflower_seed_card, 3))
	cards.append_array(repeat_card(soil_card, 3))
	cards.append_array(repeat_card(water_card, 3))
	shuffle()

func repeat_card(card: CardData, times: int) -> Array[CardData]:
	var arr: Array[CardData] = []
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

func discard(card: CardData):
	discard_pile.append(card)

func replenish():
	cards.append_array(discard_pile)
	discard_pile.clear()
	shuffle()
	
func is_empty():
	return cards.size() == 0
