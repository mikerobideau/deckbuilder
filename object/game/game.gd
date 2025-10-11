class_name Game
extends Control

var seed: int
var rng: RandomNumberGenerator

enum GamePhase {
	NEW_GAME,
	START_GAME,
	ROUND,
	SHOP,
	GAME_OVER,
}

var NewGame = preload("res://object/menu/new_game/new_game.tscn")
var GameOver = preload("res://object/menu/game_over/game_over.tscn")
var Round = preload("res://object/round/round.tscn")
var Shop = preload("res://object/shop/shop.tscn")

var phase: GamePhase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_transition(GamePhase.NEW_GAME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _transition(phase: GamePhase):
	_clear_scenes()
	self.phase = phase
	match phase:
		GamePhase.NEW_GAME:
			_open_new_game()
		GamePhase.START_GAME:
			_start_game()
		GamePhase.ROUND:
			_start_round()
		GamePhase.SHOP:
			_open_shop()
		GamePhase.GAME_OVER:
			_open_game_over()
	
func _open_new_game():
	var new_game = NewGame.instantiate()
	new_game.new_game_clicked.connect(_on_new_game_clicked)
	add_child(new_game)

func _start_game():
	randomize()
	var seed_str = random_seed()
	init_rng(seed_str)
	_transition(GamePhase.ROUND)

func _start_round():
	var round = Round.instantiate()
	round.round_completed.connect(_on_round_completed)
	round.game_over.connect(_on_game_over)
	add_child(round)
	
func _on_new_game_clicked():
	_transition(GamePhase.ROUND)
	
func _on_round_completed():
	print_debug('on round completed')
	_transition(GamePhase.SHOP)
	
func _on_game_over():
	_transition(GamePhase.GAME_OVER)
	
func _open_game_over():
	var game_over = GameOver.instantiate()
	game_over.new_game_clicked.connect(_on_new_game_clicked)
	add_child(game_over)
	
func _open_shop():
	var shop = Shop.instantiate()
	add_child(shop)

#Helpers

func _clear_scenes():
	for child in get_children():
		child.queue_free()

func random_seed(length := 7) -> String:
	var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	var result := ""
	for i in length:
		var index = randi() % chars.length()
		result += chars[index]
	return result
	
func init_rng(seed_str: String):
	rng = RandomNumberGenerator.new()
	seed = seed_str.hash()
	rng.seed = seed
