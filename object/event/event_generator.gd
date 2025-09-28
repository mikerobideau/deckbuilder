class_name EventGenerator
extends RefCounted

var Generator = preload("res://util/generator.gd")

var generator: Generator
var events: Array[EventData]
var rng: RandomNumberGenerator

func _init(rng: RandomNumberGenerator):
	self.rng = rng
	self.generator = Generator.new(rng)
	events = Database.event.all_events()
	
func generate() -> EventData:
	return generator.gen(events) as EventData
