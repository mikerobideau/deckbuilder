class_name CardGenerator
extends RefCounted

var Generator = preload("res://util/generator.gd")
var CardFactory = preload("res://object/card/card_factory.gd")

var generator: Generator
var cards: Array[BaseCardData]
var rng: RandomNumberGenerator
var card_factory: CardFactory

func _init(rng: RandomNumberGenerator):
	self.rng = rng
	self.generator = Generator.new(rng)
	card_factory = CardFactory.new()
	cards = Database.card.all_cards()
	
func generate() -> BaseCard:
	var card_data = generator.gen(cards) as BaseCardData
	var card = card_factory.create(card_data)
	return card
