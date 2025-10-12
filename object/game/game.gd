class_name Game
extends Control

var seed: int
var rng: RandomNumberGenerator

enum GamePhase {
	NEW_GAME,
	ROUND,
	SHOP,
	GAME_OVER,
}

@onready var screen_container = $Screen
@onready var ui = $UI
@onready var currency = $UI/TopBar/Currency
@onready var deck = $UI/Deck

var NewGame = preload("res://object/menu/new_game/new_game.tscn")
var GameOver = preload("res://object/menu/game_over/game_over.tscn")
var Round = preload("res://object/round/round.tscn")
var Shop = preload("res://object/shop/shop.tscn")

var phase: GamePhase
var start_phase = GamePhase.SHOP

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.visible = true
	_transition(GamePhase.NEW_GAME)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _transition(phase: GamePhase):
	self.phase = phase
	match phase:
		GamePhase.NEW_GAME:
			_open_new_game()
		GamePhase.ROUND:
			_open_round()
		GamePhase.SHOP:
			_open_shop()
		GamePhase.GAME_OVER:
			_open_game_over()
	
func _open_new_game():
	var new_game = NewGame.instantiate()
	new_game.new_game_clicked.connect(_on_new_game_clicked)
	_set_screen(new_game)

func _start_game():
	randomize()
	var seed_str = random_seed()
	init_rng(seed_str)
	deck.setup(rng)
	currency.set_currency(Const.BASE_CURRENCY)
	_transition(start_phase)

func _open_round():
	var round = Round.instantiate()
	round.deck = deck
	round.currency = currency
	round.round_completed.connect(_on_round_completed)
	round.game_over.connect(_on_game_over)
	_set_screen(round)
	round.setup(rng)
	
func _on_new_game_clicked():
	_start_game()
	
func _on_round_completed():
	_transition(GamePhase.SHOP)
	
func _on_game_over():
	_transition(GamePhase.GAME_OVER)
	
func _open_game_over():
	var game_over = GameOver.instantiate()
	game_over.new_game_clicked.connect(_on_new_game_clicked)
	_set_screen(game_over)
	
func _open_shop():
	var shop = Shop.instantiate()
	shop.currency = currency
	shop.deck = deck
	shop.shop_exited.connect(_on_shop_exited)
	_set_screen(shop)
	shop.setup(rng)
	
func _on_shop_exited():
	_transition(GamePhase.ROUND)

#Helpers

func _set_screen(screen: Node):
	for child in screen_container.get_children():
		child.queue_free()
	if phase == GamePhase.ROUND or phase == GamePhase.SHOP:
		ui.visible = true
	else:
		ui.visible = false
	screen_container.add_child(screen)

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
