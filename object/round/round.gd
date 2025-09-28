class_name Round
extends Control

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var table = $TableContainer/Table
@onready var garden = $Garden

var hand_scene = preload("res://object/hand/hand.tscn")
var RecipeMatcher = preload("res://object/recipe/recipe_matcher.gd")
var BaseCardScene = preload("res://object/card/base_card.tscn")

var recipe_matcher: RecipeMatcher
var card_factory = CardFactory.new()
var rng = RandomNumberGenerator.new()
var event_generator = EventGenerator.new(rng)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recipe_matcher = RecipeMatcher.new()
	deck.card_drawn.connect(hand.on_card_drawn)
	deck.shuffle()
	draw()

func draw():
	var num_to_draw = 7 - hand.cards.size()
	for i in num_to_draw:
		deck.draw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	var played_cards = hand.selected_cards.duplicate()
	_play(played_cards)
	_generate_event()
	
func _play(played_cards: Array) -> void:
	var ingredients = hand.get_selected_card_data()
	var match = match_recipe(ingredients)

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

	await get_tree().create_timer(0.5).timeout

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

	if match:
		add_plant(match.output)
	draw()

func match_recipe(ingredients: Array[CardData]):
	var match = recipe_matcher.match(hand.get_selected_card_data())
	if !match:
		push_warning('Round - No matching recipe found')
	return match
	
func add_plant(data: PlantData) -> void:
	var plant = card_factory.create_plant(data)
	garden.add_plant(plant)
	
func _generate_event():
	var event_data = event_generator.generate()
	print('Generated event: ' + event_data.name)
