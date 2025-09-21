class_name Round
extends Control

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var table = $TableContainer/Table

var hand_scene = preload("res://object/hand/hand.tscn")
var RecipeMatcher = preload("res://object/recipe/recipe_matcher.gd")

var recipe_matcher: RecipeMatcher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	recipe_matcher = RecipeMatcher.new()
	deck.card_drawn.connect(hand.on_card_drawn)
	deck.shuffle()
	for i in 7:
		deck.draw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	var played_cards = hand.selected_cards.duplicate()
	var ingredients = hand.get_selected_card_data()
	var matched_recipe = match_recipe(ingredients)
	_play_selected_cards_to_table()
	hand.selected_cards.clear()

func _play_selected_cards_to_table():
	var played_cards = hand.selected_cards.duplicate()
	for i in played_cards.size():
		var card = played_cards[i]
		var end_pos = table.get_slot_position(i)
		_play_card_to_table(card, end_pos)

func _play_card_to_table(card: Card, end_pos: Vector2) -> void:
	var start_pos = card.get_global_position()
	hand.cards.erase(card)
	hand.selected_cards.erase(card)
	hand._layout_cards()

	card.reparent(self)
	card.global_position = start_pos

	table.cards.append(card)

	var tween = create_tween().set_parallel(true)
	tween.tween_property(card, "global_position", end_pos, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "rotation_degrees", 0.0, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.finished.connect(func() -> void:
		card.reparent(table)
		await get_tree().create_timer(0.5).timeout
		var fade_tween = create_tween()
		fade_tween.tween_property(card, "modulate:a", 0.0, 0.3)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await fade_tween.finished
		table.cards.erase(card)
		card.queue_free()
	)
	
func match_recipe(ingredients: Array[CardData]):
	var match = recipe_matcher.match(hand.get_selected_card_data())
	if match:
		print('You played a ' + match.name + '!')
	else:
		print('No matching recipe found')
	return match
