class_name Round
extends Control

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var table = $Board/TableContainer/Table
@onready var garden = $Board/Garden
@onready var event_row = $Board/EventRow

var RecipeMatcher = preload("res://object/recipe/recipe_matcher.gd")
var BaseCardScene = preload("res://object/card/base_card.tscn")
var EffectContext = preload("res://object/effect/effect_context.gd")

signal hand_played
signal hand_animation_completed(recipe: Recipe)
signal recipe_completed()
signal plant_effects_completed()
signal events_completed()
signal event_generated()

var recipe_matcher: RecipeMatcher
var card_factory = CardFactory.new()
var rng = RandomNumberGenerator.new()
var event_generator = EventGenerator.new(rng)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_played.connect(_play)
	hand_animation_completed.connect(_after_hand_played)
	recipe_completed.connect(_on_recipe_completed)
	plant_effects_completed.connect(_on_plant_effects_completed)
	events_completed.connect(_on_events_completed)
	event_generated.connect(_on_event_generated)
	
	recipe_matcher = RecipeMatcher.new()
	deck.card_drawn.connect(hand.on_card_drawn)
	deck.shuffle()
	draw()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()

func _on_play_button_pressed() -> void:
	hand_played.emit()
	
func _play() -> void:
	var played_cards = hand.selected_cards.duplicate()
	var match = _match_recipe(hand.get_selected_card_data())

	for card in played_cards:
		hand.cards.erase(card)
	hand.selected_cards.clear()
	hand._layout_cards()

	for i in played_cards.size():
		var card = played_cards[i]
		var end_pos = table.get_slot_position(i)
		var start_pos = card.get_global_position()

		card.reparent(self)
		card.global_position = start_pos
		table.cards.append(card)

		var move_tween = create_tween().set_parallel(true)
		move_tween.tween_property(card, "global_position", end_pos, 0.3)
		move_tween.tween_property(card, "rotation_degrees", 0.0, 0.3)

		card.reparent(table)

	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout

	# Fade all cards in parallel
	var remaining = played_cards.size()
	for card in played_cards:
		var fade_tween = create_tween()
		fade_tween.tween_property(card, "modulate:a", 0.0, 0.3)
		fade_tween.finished.connect(func():
			remaining -= 1
			if remaining == 0:
				# Remove and free all cards after fading
				for c in played_cards:
					table.cards.erase(c)
					c.queue_free()
		)
		deck.discard(card.data)
		
	hand_animation_completed.emit(match)
		
func _after_hand_played(recipe: Recipe):
	if recipe:
		await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
		add_plant(recipe.output)
	
	recipe_completed.emit()
	
func _on_recipe_completed():
	var context = get_effect_context()
	await garden.apply_all(context)
	plant_effects_completed.emit()
	
func _on_plant_effects_completed():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	var context = get_effect_context()
	await event_row.apply_all(context)
	events_completed.emit()
	
func _on_events_completed():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	_generate_event()
	event_generated.emit()
	
func _on_event_generated():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
	draw()

func _match_recipe(ingredients: Array[CardData]):
	var match = recipe_matcher.match(hand.get_selected_card_data())
	if !match:
		push_warning('Round - No matching recipe found')
	return match
	
func add_plant(data: PlantData) -> void:
	var plant = card_factory.create_plant(data)
	garden.add_plant(plant)
	
func _generate_event():
	var event = event_generator.generate()
	var context = get_effect_context()
	event_row.add_event(event)

func get_effect_context() -> EffectContext:
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
	return context
