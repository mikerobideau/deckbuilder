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
	for card in played_cards:
		_play_card_to_table(card)
	match_recipe(ingredients)
	hand.selected_cards.clear()

func _play_card_to_table(card: Card) -> void:
	var start_pos = card.get_global_position()

	# Add to table tracking first
	table.cards.append(card)
	var end_pos = table.get_next_slot_position(table.cards.size() - 1)

	# Reparent to Round for free global animation
	card.reparent(self)
	card.set_global_position(start_pos)

	var tween = create_tween().set_parallel(true)
	tween.tween_property(card, "global_position", end_pos, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "rotation_degrees", 0.0, 0.3)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.finished.connect(func():
		card.reparent(table)
		#t0aa0layout_cards()
	)
	
func match_recipe(ingredients: Array[CardData]):
	var match = recipe_matcher.match(hand.get_selected_card_data())
	if match:
		print('You played a ' + match.name + '!')
	else:
		print('No matching recipe found')
