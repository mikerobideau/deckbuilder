class_name EnemyGenerator
extends RefCounted

var Generator = preload("res://util/generator.gd")
var CardFactory = preload("res://object/card/card_factory.gd")

var generator: Generator
var enemies: Array[EnemyData]
var rng: RandomNumberGenerator
var card_factory: CardFactory

func _init(rng: RandomNumberGenerator):
	self.rng = rng
	self.generator = Generator.new(rng)
	card_factory = CardFactory.new()
	enemies = Database.enemy.all_enemies()
	
func generate() -> Enemy:
	var event_data = generator.gen(enemies) as EnemyData
	return card_factory.create(event_data)
