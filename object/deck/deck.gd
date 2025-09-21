extends Node
class_name Deck

@export var cook_path: String = "res://resource/card/cook.tres"
@export var mix_path: String = "res://resource/card/mix.tres"
@export var cut_path: String = "res://resource/card/cut.tres"
@export var serve_path: String = "res://resource/card/serve.tres"
@export var mushroom_path: String = "res://resource/card/mushroom.tres"

signal card_drawn(card: CardData)

var cards: Array[CardData] = []
var discard_pile: Array[CardData] = []

func _ready():
	var cook_card = load(cook_path) as CardData
	var mix_card = load(mix_path) as CardData
	var cut_card = load(cut_path) as CardData
	var serve_card = load(serve_path) as CardData
	var mushroom_card = load(mushroom_path) as CardData
	
	cards.clear()
	cards.append_array(repeat_card(cook_card, 2))
	cards.append_array(repeat_card(mix_card, 2))
	cards.append_array(repeat_card(cut_card, 2))
	cards.append_array(repeat_card(serve_card, 2))
	cards.append_array(repeat_card(mushroom_card, 2))
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
