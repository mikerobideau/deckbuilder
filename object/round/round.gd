class_name Round
extends Control

signal discard_completed()
signal round_completed()
signal game_over()

enum RoundState {
	IDLE,
	CARD_PLAYED,
	COMPLETED,
	GAME_OVER		
}

@onready var hand = $HandContainer/Hand
@onready var board = $ControlBoard
@onready var play_button = $Actions/PlayButton
@onready var discard_button = $Actions/DiscardButton
@onready var base_health = $Health
@onready var target_manager = TargetManager.new()
@onready var ai = $AI

var BaseCardScene = preload("res://object/card/base_card.tscn")
var EffectContext = preload("res://object/effect/effect_context.gd")
var state = RoundState.IDLE
var turns_remaining = Const.TURNS_PER_ROUND
var discards_remaining = Const.DISCARDS_PER_ROUND
var card_factory = CardFactory.new()
var rng: RandomNumberGenerator
var currency: Currency
var deck: Deck
var _pending_cell: Cell = null

func _ready():
	await get_tree().process_frame #ensure filesystem is ready
	add_child(target_manager)
	_connect_signals()
	_setup_board()
	draw()
	_transition_to_idle()
	_update_button_labels()
	base_health.set_health(Const.BASE_HEALTH)
	
func _process(delta: float) -> void:
	pass
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng
	board.setup(rng)
	ai.setup(rng, board)
	
func _setup_board():
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var board_size: Vector2 = board.get_size()
	var x := (viewport_size.x - board_size.x) / 2
	var y := 150.0
	board.position = Vector2(x, y)

func _connect_signals() -> void:
	deck.card_drawn.connect(hand.on_card_drawn)
	discard_completed.connect(_on_discard_completed)
	base_health.base_health_depleted.connect(_on_base_health_depleted)
	hand.selected_cards_changed.connect(_on_selected_cards_changed)

# ---- Transitions ----

func _transition_to_idle():
	if !validate_transition():
		return
	state = RoundState.IDLE
	target_manager.enable_input()
	hand.enable_input()

func _transition_to_card_played():
	if !validate_transition():
		return
	state = RoundState.CARD_PLAYED
	hand.disable_input()

func _transition_to_completed():
	if !validate_transition():
		return
	state = RoundState.COMPLETED
	round_completed.emit()

func _transition_to_game_over():
	if !validate_transition():
		return
	state = RoundState.GAME_OVER
	game_over.emit()

func validate_transition():
	if state == RoundState.COMPLETED or state == RoundState.GAME_OVER:
		return false
	return true

# ---- Play turn ----

func _on_play_button_pressed() -> void:
	if state != RoundState.IDLE or !_is_valid_play() or turns_remaining == 0:
		return
	_transition_to_card_played()
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	
	if played_cards.size() == 1:
		var card = played_cards[0]
		if card is Hero:
			await _play_hero(card)
		if card is Item:
			await _play_item(card)
		card.deselect()
		target_manager.deselect()
		target_manager.disable_input()
		await Animate.delay()
		await _enemy_turn()
		await Animate.delay()
		_end_turn()
	
func _play_hero(hero: Hero) -> void:
	if !_pending_cell:
		return
	board.place_unit_on_cell(hero, _pending_cell)
	hero.set_location_to_board()
	hero.unit_card_targeted.connect(target_manager.select)
	hero.unit_card_health_depleted.connect(_on_unit_card_health_depleted)
	_remove_from_hand([hero], false)
	_cancel_pending_cell_selection()

func _play_item(card: Item):
	var context = _get_effect_context()
	await card.apply(context)
	_discard(card)

func _enemy_turn():
	var context = _get_effect_context()
	await ai.play_all(context)
	_spawn_enemy()

func _spawn_enemy():
	var spawn = ai.spawn()
	if !spawn.enemy: return
	var enemy = spawn.enemy
	enemy.setup(rng)
	enemy.unit_card_health_depleted.connect(_on_unit_card_health_depleted)
	enemy.unit_card_targeted.connect(target_manager.select)
	board.place_unit(enemy, spawn.x, spawn.y)	

func _end_turn():
	turns_remaining = turns_remaining - 1
	_update_button_labels()
	for hero in board.get_heroes():
		if hero:
			hero.after_turn()
	for enemy in board.get_enemies():
		if enemy:
			enemy.after_turn()
	if turns_remaining > 0:
		_transition_to_idle()
		draw()
	else:
		_transition_to_completed()
	
func _is_valid_play() -> bool:
	if hand.selected_cards.size() != 1:
		return false
	var card = hand.selected_cards[0]
	if card is Item and (!card.data.has_targets or target_manager.selection != null):
		return true
	if card is Hero:
		return true
	return false
	
# ---- Deck and hand ----

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()
	
func _on_discard_pressed() -> void:
	if discards_remaining == 0 or state != RoundState.IDLE:
		return
	discards_remaining = discards_remaining - 1
	_update_button_labels()
	_discard_all(hand.selected_cards.duplicate())
	await Animate.delay()
	draw()
	discard_completed.emit()
	
func _on_discard_completed() -> void:
	_transition_to_idle()

func _on_pass_pressed() -> void:
	if state != RoundState.IDLE:
		return
	_end_turn()
	hand.deselect_all()
	
func _discard(card: BaseCard):
	_discard_all([card])
	
func _discard_all(played_cards: Array[BaseCard], destroy = false):
	_remove_from_hand(played_cards)
	if !destroy:
		for card in played_cards:
			deck.discard(card.data)

func _remove_from_hand(played_cards: Array[BaseCard], free_nodes: bool = true) -> void:
	hand.remove_all(played_cards, free_nodes)
	hand.layout_cards()

func _add_hero_to_hand(data: HeroData) -> void:
	var hero = card_factory.create(data)
	hand.add_card(hero)
	
func _on_selected_cards_changed(cards: Array[BaseCard]) -> void:
	_cancel_pending_cell_selection()
	if state != RoundState.IDLE or cards.size() != 1:
		return
	var card := cards[0]
	if card is Hero:
		board.begin_placement(ControlBoard.ZoneType.HERO)
		_pending_cell = await board.placement_confirmed
	else:
		board.cancel_placement()

# ---- Health depleted ----

func _on_unit_card_health_depleted(card: UnitCard):
	if card is Hero:
		_exhaust_hero(card as Hero)
	if card is Enemy:
		_exhaust_enemy(card as Enemy)
	target_manager.cleanup_reference(card)
	
func _on_base_health_depleted():
	_transition_to_game_over()
	
func _exhaust_hero(hero: Hero):
	deck.exhaust(hero)
	board.remove_unit(hero)
	hero.queue_free()
	
func _exhaust_enemy(enemy: Enemy):
	board.remove_unit(enemy)
	enemy.queue_free()
	
# ---- Effect context ----

func _get_effect_context() -> EffectContext:
	var context = EffectContext.new()
	var heroes: Array[UnitCard]  = []
	var enemies: Array[UnitCard] = []
	for hero in board.get_heroes():
		if hero:
			heroes.append(hero)
	context.heroes = heroes
	for enemy in board.get_enemies():
		if enemy:
			enemies.append(enemy)
	context.enemies = enemies
	context.selected_unit = target_manager.selection
	context.base_health = base_health
	context.currency = currency
	return context

# ---- Board Selection ----
	
func _cancel_pending_cell_selection():
	_pending_cell = null
	board.cancel_placement()

# ---- Actions ----

func _update_button_labels():
	play_button.text = 'PLAY (' + str(turns_remaining) + ')'
	discard_button.text = 'DISCARD (' + str(discards_remaining) + ')'
