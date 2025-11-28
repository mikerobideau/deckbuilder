class_name BoardObjectGenerator
extends RefCounted

var Generator = preload("res://util/generator.gd")
var CardFactory = preload("res://object/card/card_factory.gd")

var generator: Generator
var board_objects: Array[BoardObjectData]
var rng: RandomNumberGenerator
var card_factory: CardFactory

func _init(rng: RandomNumberGenerator):
	self.rng = rng
	self.generator = Generator.new(rng)
	card_factory = CardFactory.new()
	board_objects = Database.board_object.all_board_objects()
	
func generate_vault() -> Enemy:
	var data = Database.board_object.get_vault()
	return card_factory.create(data)
