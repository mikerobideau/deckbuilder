class_name Round
extends Control

signal play_completed()
signal plant_effects_completed()
signal events_completed()
signal event_generated()
signal craft_completed(recipe: Recipe)
signal discard_completed()

enum RoundState {
	IDLE,          # Waiting for player input
	CARD_PLAYED,   # A card was played, waiting for effects
	RESOLVING,     # Effects/animations resolving
	COMPLETED      # End of round
}

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var garden = $BoardContainer/Board/Garden
@onready var event_row = $BoardContainer/Board/EventRow
@onready var target_manager = TargetManager.new()

var state = RoundState.IDLE
var RecipeMatcher = preload("res://object/recipe/recipe_matcher.gd")
var BaseCardScene = preload("res://object/card/base_card.tscn")
var EffectContext = preload("res://object/effect/effect_context.gd")
var recipe_matcher: RecipeMatcher
var card_factory = CardFactory.new()
var rng = RandomNumberGenerator.new()
var event_generator = EventGenerator.new(rng)

func _ready():
	add_child(target_manager)
	_connect_signals()	
	recipe_matcher = RecipeMatcher.new()
	deck.shuffle()
	draw()
	transition_to_idle()
	
func _process(delta: float) -> void:
	pass
	
func _connect_signals() -> void:
	deck.card_drawn.connect(hand.on_card_drawn)
	play_completed.connect(_on_hand_played)
	plant_effects_completed.connect(_on_plant_effects_completed)
	events_completed.connect(_on_events_completed)
	event_generated.connect(_on_event_generated)
	discard_completed.connect(_on_discard_completed)
	
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
	state = RoundState.IDLE
	target_manager.deselect()
	target_manager.enable_input()
	hand.enable_input()

func transition_to_card_played():
	state = RoundState.CARD_PLAYED
	target_manager.disable_input()
	hand.disable_input()

func transition_to_resolving():
	state = RoundState.RESOLVING

func transition_to_completed():
	state = RoundState.COMPLETED



#Signal Callbacks

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()

func _on_play_button_pressed() -> void:
	if state != RoundState.IDLE or !_is_valid_play():
		return
	transition_to_card_played()
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	if played_cards.size() == 1:
		var card = played_cards[0]
		if card is Plant:
			_play_plant(card)
		if card is Card:
			_play_item(card)
	play_completed.emit()

func _on_hand_played():
	transition_to_resolving()
	_play_all_plants()
	
func _on_plant_effects_completed():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	var context = _get_effect_context()
	await event_row.apply_all(context)
	events_completed.emit()
	
func _on_events_completed():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	_generate_event()
	event_generated.emit()

func _on_event_generated():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	draw()
	transition_to_idle()
	
func _on_craft_button_pressed() -> void:
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	var match = _match_recipe(hand.get_selected_card_data())
	_discard_all(played_cards, true)
	craft_completed.emit(match)
	
func _on_discard_pressed() -> void:
	transition_to_resolving()
	_discard_all(hand.selected_cards.duplicate())
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	draw()
	discard_completed.emit()
	
func _on_discard_completed() -> void:
	transition_to_idle()

#Helpers

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
	return context

func _match_recipe(ingredients: Array[BaseCardData]):
	var cards = hand.get_selected_card_data()
	var match = recipe_matcher.match(cards)
	if !match:
		push_warning('Round - No matching recipe found')
	return match

func _add_plant_to_hand(data: PlantData) -> void:
	var plant = card_factory.create(data)
	hand.add_card(plant)
	
func _generate_event():
	var event = event_generator.generate()
	event_row.add_event(event)
	event.set_location_to_board()
	event.unit_card_targeted.connect(target_manager.select)

func _play_plant(plant: Plant) -> void:
	garden.add_plant(plant)
	plant.set_location_to_board()
	plant.unit_card_targeted.connect(target_manager.select)
	_remove_from_hand([plant], false)
	
func _play_item(card: Card):
	var context = _get_effect_context()
	card.apply(context)
	_discard(card)

func _play_all_plants():
	var context = _get_effect_context()
	await garden.apply_all(context)
	plant_effects_completed.emit()
