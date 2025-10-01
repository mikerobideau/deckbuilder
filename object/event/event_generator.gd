class_name EventGenerator
extends RefCounted

var Generator = preload("res://util/generator.gd")
var CardFactory = preload("res://object/card/card_factory.gd")

var generator: Generator
var events: Array[EventData]
var rng: RandomNumberGenerator
var card_factory: CardFactory

func _init(rng: RandomNumberGenerator):
	self.rng = rng
	self.generator = Generator.new(rng)
	card_factory = CardFactory.new()
	events = Database.event.all_events()
	
func generate() -> Event:
	var event_data = generator.gen(events) as EventData
	return card_factory.create_event(event_data)
