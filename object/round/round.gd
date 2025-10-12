class_name Round
extends Control

signal play_completed()
signal plant_effects_completed()
signal events_completed()
signal event_generated()
signal craft_completed(recipe: Recipe)
signal discard_completed()
signal round_completed()
signal game_over()

enum RoundState {
	IDLE,
	CARD_PLAYED,
	RESOLVING, 
	COMPLETED,
	GAME_OVER		
}

@onready var recipe_manager = $RecipeManager
@onready var garden = $BoardContainer/Board/Garden
@onready var event_row = $BoardContainer/Board/EventRow
@onready var hand = $HandContainer/Hand
@onready var play_button = $Actions/PlayButton
@onready var discard_button = $Actions/DiscardButton
@onready var base_health = $Health
@onready var target_manager = TargetManager.new()

var BaseCardScene = preload("res://object/card/base_card.tscn")
var EffectContext = preload("res://object/effect/effect_context.gd")
var state = RoundState.IDLE
var days_remaining = Const.DAYS_PER_ROUND
var discards_remaining = Const.DISCARDS_PER_ROUND
var card_factory = CardFactory.new()
var rng: RandomNumberGenerator
var event_generator: EventGenerator
var currency: Currency
var deck: Deck

func _ready():
	await get_tree().process_frame #ensure filesystem is ready
	add_child(target_manager)
	_connect_signals()
	draw()
	transition_to_idle()
	_update_button_labels()
	base_health.set_health(Const.BASE_HEALTH)
	
func _process(delta: float) -> void:
	pass
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng
	event_generator = EventGenerator.new(rng)
	
func _connect_signals() -> void:
	deck.card_drawn.connect(hand.on_card_drawn)
	play_completed.connect(_on_hand_played)
	plant_effects_completed.connect(_on_plant_effects_completed)
	events_completed.connect(_on_events_completed)
	event_generated.connect(_on_event_generated)
	discard_completed.connect(_on_discard_completed)
	hand.selected_cards_changed.connect(_on_selected_cards_changed)
	base_health.base_health_depleted.connect(_on_base_health_depleted)
	
	for bed in garden.beds:
		bed.garden_bed_selected.connect(target_manager.select)
	for plant in garden.get_plants():
		if plant:
			plant.unit_card_targeted.connect(target_manager.select)
	for event in event_row.get_events():
		if event:
			event.unit_card_targeted.connect(target_manager.select)



#Transitions

func transition_to_idle():
	if !validate_transition():
		return
	state = RoundState.IDLE
	target_manager.deselect()
	target_manager.enable_input()
	hand.enable_input()

func transition_to_card_played():
	if !validate_transition():
		return
	state = RoundState.CARD_PLAYED
	target_manager.disable_input()
	hand.disable_input()

func transition_to_resolving():
	if !validate_transition():
		return
	recipe_manager.clear()
	state = RoundState.RESOLVING

func transition_to_completed():
	if !validate_transition():
		return
	state = RoundState.COMPLETED
	round_completed.emit()

func transition_to_game_over():
	if !validate_transition():
		return
	state = RoundState.GAME_OVER
	game_over.emit()

func validate_transition():
	if state == RoundState.COMPLETED or state == RoundState.GAME_OVER:
		return false
	return true

#Signal Callbacks

func _on_play_button_pressed() -> void:
	if state != RoundState.IDLE or !_is_valid_play() or days_remaining == 0:
		return
	transition_to_card_played()
	_end_day()
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	if played_cards.size() == 1:
		var card = played_cards[0]
		if card is Plant:
			_play_plant(card)
		if card is Card:
			_play_item(card)
	play_completed.emit()
	
func _end_day():
	days_remaining = days_remaining - 1
	_update_button_labels()

func _on_hand_played():
	transition_to_resolving()
	_play_all_plants()
	
func _on_plant_effects_completed():
	_apply_all_events()
	
func _on_events_completed():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	_generate_event()
	event_generated.emit()

func _on_event_generated():
	_turn_complete()
	
func _on_craft_button_pressed() -> void:
	if state != RoundState.IDLE:
		return
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	var match = recipe_manager.match(played_cards)
	if match:
		recipe_manager.clear()
		var new_card = card_factory.create(match.output)
		hand.add_card(new_card)
	_discard_all(played_cards, true)
	craft_completed.emit(match)
	
func _on_discard_pressed() -> void:
	if discards_remaining == 0 or state != RoundState.IDLE:
		return
	transition_to_resolving()
	discards_remaining = discards_remaining - 1
	_update_button_labels()
	_discard_all(hand.selected_cards.duplicate())
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	draw()
	discard_completed.emit()
	
func _on_discard_completed() -> void:
	transition_to_idle()

func _on_pass_pressed() -> void:
	if state != RoundState.IDLE:
		return
	_end_day()
	hand.deselect_all()
	transition_to_resolving()
	_play_all_plants()
	
func _on_selected_cards_changed(cards: Array[BaseCard]) -> void:
	var match = recipe_manager.match(cards)
	if match:
		recipe_manager.set_text(match.name)
	else:
		recipe_manager.set_text('')
		
func _on_unit_card_health_depleted(card: UnitCard):
	if card is Plant:
		_exhaust_plant(card as Plant)
	if card is Event:
		_exhaust_event(card as Event)
	target_manager.cleanup_reference(card)
	
func _on_base_health_depleted():
	transition_to_game_over()
	
	
#Helpers

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()

func _is_valid_play() -> bool:
	if hand.selected_cards.size() != 1:
		return false
	var card = hand.selected_cards[0]
	if card is Card and target_manager.selection != null:
		return true
	if card is Plant:
		return true
	return false

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
	
func _get_effect_context() -> EffectContext:
	var context = EffectContext.new()
	var plants: Array[UnitCard] = []
	var events: Array[UnitCard] = []
	for plant in garden.get_plants():
		if plant:
			plants.append(plant)
	context.plants = plants
	for event in event_row.get_events():
		if event:
			events.append(event)
	context.events = events
	context.selected_unit = target_manager.selection
	context.base_health = base_health
	context.currency = currency
	return context

func _add_plant_to_hand(data: PlantData) -> void:
	var plant = card_factory.create(data)
	hand.add_card(plant)
	
func _generate_event():
	var event = event_generator.generate()
	event.unit_card_health_depleted.connect(_on_unit_card_health_depleted)
	event_row.add_event(event)
	event.set_location_to_board()
	event.unit_card_targeted.connect(target_manager.select)

func _play_plant(plant: Plant) -> void:
	garden.add_plant(plant)
	plant.set_location_to_board()
	plant.unit_card_targeted.connect(target_manager.select)
	plant.unit_card_health_depleted.connect(_on_unit_card_health_depleted)
	_remove_from_hand([plant], false)
	
func _play_item(card: Card):
	var context = _get_effect_context()
	card.apply(context)
	_discard(card)

func _play_all_plants():
	var context = _get_effect_context()
	await garden.apply_all(context)
	plant_effects_completed.emit()

func _apply_all_events():
	for event in event_row.get_events():
		if event != null:
			await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
			var context = _get_effect_context()
			await event.apply(context)
	events_completed.emit()

func _update_button_labels():
	play_button.text = 'PLAY (' + str(days_remaining) + ')'
	discard_button.text = 'DISCARD (' + str(discards_remaining) + ')'
	
func _turn_complete():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	if days_remaining > 0:
		transition_to_idle()
		draw()
	else:
		transition_to_completed()

func _exhaust_plant(plant: Plant):
	deck.exhaust(plant)
	garden.remove_plant(plant)
	plant.queue_free()
	
func _exhaust_event(event: Event):
	event_row.remove_event(event)
	event.queue_free()
