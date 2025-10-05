class_name Round
extends Control

signal play_completed()
signal craft_completed(recipe: Recipe)
signal plant_effects_completed()
signal events_completed()
signal event_generated()

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var garden = $Board/Garden
@onready var event_row = $Board/EventRow

var RecipeMatcher = preload("res://object/recipe/recipe_matcher.gd")
var BaseCardScene = preload("res://object/card/base_card.tscn")
var EffectContext = preload("res://object/effect/effect_context.gd")
var recipe_matcher: RecipeMatcher
var card_factory = CardFactory.new()
var rng = RandomNumberGenerator.new()
var event_generator = EventGenerator.new(rng)
var selection: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()	
	recipe_matcher = RecipeMatcher.new()
	deck.shuffle()
	draw()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _connect_signals() -> void:
	deck.card_drawn.connect(hand.on_card_drawn)
	play_completed.connect(_after_hand_played)
	craft_completed.connect(_after_craft)
	plant_effects_completed.connect(_on_plant_effects_completed)
	events_completed.connect(_on_events_completed)
	event_generated.connect(_on_event_generated)
	
	for bed in garden.beds:
		bed.garden_bed_selected.connect(_on_target_selected)
	
	for plant in garden.get_plants():
		if plant:
			plant.unit_card_selected.connect(_on_target_selected)
		
	for event in event_row.get_events():
		if event:
			event.unit_card_selected.connect(_on_target_selected)

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()

func _on_target_selected(target: Node) -> void:
	print_debug('on target selected')
	if selection:
		selection.set_selected(false)
	if selection == target:
		selection = null
	else:
		selection = target
		selection.set_selected(true)

func _on_play_button_pressed() -> void:
	_play()

func _on_craft_button_pressed() -> void:
	_craft()
	
func _craft() -> void:	
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	var match = _match_recipe(hand.get_selected_card_data())
	_discard_all(played_cards)
	craft_completed.emit(match)
		
func _play():
	var played_cards: Array[BaseCard] = hand.selected_cards.duplicate()
	if played_cards.size() == 1:
		var card = played_cards[0]
		var context = _get_effect_context()
		card.apply(context)
		_discard_all([card])
	play_completed.emit()
	
func _discard_all(played_cards: Array[BaseCard]):
	hand.remove_all(played_cards)
	for card in played_cards:
		deck.discard(card.data)
	hand.layout_cards()
		
func _after_craft(recipe: Recipe):
	if recipe:
		await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
		_add_plant(recipe.output)

func _after_hand_played():
	_play_all_plants()
	
func _on_recipe_completed():
	pass
	
func _play_all_plants():
	var context = _get_effect_context()
	await garden.apply_all(context)
	plant_effects_completed.emit()
	
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

func _match_recipe(ingredients: Array[BaseCardData]):
	var cards = hand.get_selected_card_data()
	var match = recipe_matcher.match(cards)
	if !match:
		push_warning('Round - No matching recipe found')
	return match
	
func _add_plant(data: PlantData) -> void:
	var plant = card_factory.create_plant(data)
	hand.add_card(plant)
	
func _generate_event():
	var event = event_generator.generate()
	event_row.add_event(event)
	event.unit_card_selected.connect(_on_target_selected)

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
	#TODO: prevent selected from changing while effects are being applied
	if selection is UnitCard:
		context.selected_unit = selection
	return context
