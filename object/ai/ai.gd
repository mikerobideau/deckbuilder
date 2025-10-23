class_name AI
extends Node2D

var rng: RandomNumberGenerator
var board: ControlBoard
var enemy_generator: EnemyGenerator

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func setup(rng: RandomNumberGenerator, board: ControlBoard):
	self.rng = rng
	self.board = board
	enemy_generator = EnemyGenerator.new(rng)

func spawn() -> Dictionary:
	var enemy = enemy_generator.generate()
	enemy.set_location_to_board()
	var choices = board.get_empty_cells_in_zone(ControlBoard.ZoneType.ENEMY)
	if choices.is_empty():
		push_warning("place_enemy: no empty ENEMY cells available.")
		return {'enemy': null, 'x': null, 'y': null}
	var pick = choices[rng.randi_range(0, choices.size() - 1)]
	return {'enemy': enemy, 'x': pick.x, 'y': pick.y}
	
func play_all(context: EffectContext):
	print_debug('playing at ' + str(board.get_enemies().size()))
	for enemy in board.get_enemies():
		enemy.apply(context)
