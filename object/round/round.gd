class_name Round
extends Control

@onready var deck = $Deck
@onready var hand = $HandContainer/Hand
@onready var table = $TableContainer/Table

var hand_scene = preload("res://object/hand/hand.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.card_drawn.connect(hand.on_card_drawn)
	deck.shuffle()
	for i in 7:
		deck.draw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	var played_cards = hand.selected_cards.duplicate()
	for card in played_cards:
		_play_card_to_table(card)
	hand.selected_cards.clear()

func _play_card_to_table(card: Card) -> void:
	var start_pos = card.get_global_position()

	# Add to table tracking first
	table.cards.append(card)
	var end_pos = table.get_next_slot_position(table.cards.size() - 1)

	# Reparent to Round for free global animation
	card.reparent(self)
	card.set_global_position(start_pos)

	var tween = create_tween()
	tween.tween_property(card, "global_position", end_pos, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(func():
		card.reparent(table)
		table.layout_cards()  # sets proper local position
	)
