class_name ControlBoardTest extends Node

@onready var board = $ControlBoard

var rng: RandomNumberGenerator
var card_generator: CardGenerator

func _ready() -> void:
	print_debug('ControlBoardTest _ready called')
	rng = RandomNumberGenerator.new()
	card_generator = CardGenerator.new(rng)
	_add_cards()
	
func _process(delta: float) -> void:
	pass
	
func _on_board_ready():
	print_debug('On board ready received')
	_add_cards()
	
func _add_cards():
	for r in range(ControlBoard.NUM_ROWS):
		for c in range(ControlBoard.NUM_COLUMNS):
			if rng.randi_range(0, 1) == 0:
				var hero = card_generator.generate_hero()
				print_debug('Genrated hero ' + hero.name())
				board.place_unit(hero, r, c)
