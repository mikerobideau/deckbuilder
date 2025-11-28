class_name AI
extends Node2D

var rng: RandomNumberGenerator
var board: ControlBoard
var enemy_generator: EnemyGenerator
var board_object_generator: BoardObjectGenerator

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func setup(rng: RandomNumberGenerator, board: ControlBoard):
	self.rng = rng
	self.board = board
	enemy_generator = EnemyGenerator.new(rng)
	board_object_generator = BoardObjectGenerator.new(rng)

func spawn() -> Dictionary:
	var enemy = enemy_generator.generate()
	enemy.set_location_to_board()
	var choices = board.get_empty_cells_in_zone(ControlBoard.ZoneType.ENEMY)
	if choices.is_empty():
		push_warning("place_enemy: no empty ENEMY cells available.")
		return {'enemy': null, 'x': null, 'y': null}
	var pick = choices[rng.randi_range(0, choices.size() - 1)]
	return {'enemy': enemy, 'x': pick.x, 'y': pick.y}
	
func spawn_vault() -> Dictionary:
	var vault = board_object_generator.generate_vault()
	var choices = board.get_empty_cells_in_zone(ControlBoard.ZoneType.ENEMY)
	if choices.is_empty():
		push_warning("spawn_vault: no empty ENEMY cells available.")
		return {'vault': null, 'x': null, 'y': null}
	var pick = choices[rng.randi_range(0, choices.size() - 1)]
	return {'vault': vault, 'x': pick.x, 'y': pick.y}
	
func play_all(context: EffectContext):
	for enemy in board.get_enemies():
		enemy.apply(context)
		await Animate.delay()
