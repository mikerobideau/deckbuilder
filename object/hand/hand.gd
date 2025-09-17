class_name Hand
extends Control

@export var hand_curve: Curve
@export var rotation_curve: Curve
@export var max_rotation_degrees: int
@export var x_sep: int
@export var y_min: int
@export var y_max: int

var card_scene = preload("res://object/card/card.tscn")

var cards: Array[Card] = []

func on_card_drawn(data: CardData):
	var card = card_scene.instantiate()
	add_child(card)
	card.data = data
	cards.append(card)

	card.card_clicked.connect(_on_card_clicked)
	card.card_dragged.connect(_on_card_dragged)
	card.card_released.connect(_on_card_released)

	_layout_cards()
	
func _layout_cards():
	var num_cards = cards.size()
	if num_cards == 0:
		return

	var card_width = cards[0].size.x
	var all_cards_size = card_width * num_cards + x_sep * (num_cards - 1)
	var final_x_sep = x_sep
	if all_cards_size > size.x:
		final_x_sep = (size.x - card_width * num_cards) / (num_cards - 1)
		all_cards_size = size.x

	var offset = (size.x - all_cards_size) / 2

	for i in num_cards:
		var card = cards[i]
		var y_multiplier = hand_curve.sample(1.0 / (num_cards - 1) * i)
		var rot_multiplier = rotation_curve.sample(1.0 / (num_cards - 1) * i)
		if num_cards == 1:
			y_multiplier = 0.0
			rot_multiplier = 0.0

		var final_x = offset + card_width * i + final_x_sep * i
		var final_y = y_min + y_max * y_multiplier

		card.set_base_position(Vector2(final_x, final_y))
		card.rotation_degrees = max_rotation_degrees * rot_multiplier

	for card in cards:
		card.raise()
		
func _on_card_clicked(card: Card):
	print('Hand - card clicked')
	card.set_selected(not card.selected)
	
func _on_card_dragged(card: Card):
	raise_card(card)

func _on_card_released(card: Card):
	var nearest_index = _get_nearest_index(card.position.x)
	_reorder_card(card, nearest_index)
	_layout_cards()

func _get_nearest_index(x_pos: float) -> int:
	var closest_idx = 0
	var closest_dist = INF
	for i in cards.size():
		var card = cards[i]
		var dist = abs(x_pos - card.base_position.x)
		if dist < closest_dist:
			closest_dist = dist
			closest_idx = i
	return closest_idx

func _reorder_card(card: Card, new_index: int):
	cards.erase(card)
	cards.insert(new_index, card)

func raise_card(card: Card):
	pass
	#card.raise_()
