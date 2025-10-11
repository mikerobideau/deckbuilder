class_name Deck
extends Node

signal card_drawn(card: BaseCardData)

var cards: Array[BaseCardData] = []
var discard_pile: Array[BaseCardData] = []
var exhausted_pile: Array[BaseCardData] = []
var rng: RandomNumberGenerator
var card_generator: CardGenerator

func _ready():
	pass
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng
	card_generator = CardGenerator.new(rng)
	_populate()
	shuffle()

func _populate():
	for i in range(Const.CARDS_IN_DECK):
		var card = card_generator.generate()
		cards.append(card.data)

func shuffle():
	cards.shuffle()

func draw():
	if is_empty():
		replenish()
	if is_empty():
		#print_debug('Deck is still empty after replenish.  This should not happen')
		return null
	var card = cards.pop_back()
	card_drawn.emit(card)
	return card

func discard(card: BaseCardData):
	discard_pile.append(card)
	
func exhaust(card: BaseCard):
	exhausted_pile.append(card)

func replenish():
	cards.append_array(discard_pile)
	discard_pile.clear()
	shuffle()
	
func is_empty():
	return cards.size() == 0
