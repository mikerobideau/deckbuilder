class_name Hand
extends Control

signal selected_cards_changed(cards: Array[BaseCardData])

@export var hand_curve: Curve
@export var rotation_curve: Curve
@export var max_rotation_degrees: int
@export var x_sep: int	
@export var y_min: int
@export var y_max: int

var cards: Array[BaseCard] = []
var selected_cards: Array[BaseCard] = []
var card_factory = CardFactory.new()
var input_enabled = 	false

func on_card_drawn(data: BaseCardData):
	var card = card_factory.create(data)
	add_card(card)
	
func add_card(card: BaseCard):
	card.set_location_to_hand()
	card.hand_input_enabled = true
	add_child(card)
	cards.append(card)
	card.position = get_card_position(cards.size() - 1)
	card.card_clicked.connect(_on_card_clicked)
	card.card_released.connect(_on_card_released)
	layout_cards()
	
func get_card_position(i: int) -> Vector2:
	return Vector2(Const.CARD_SIZE.x * i, 0)
	
func layout_cards():
	for card in cards:
		card.raise()
	
func layout_cards_old():
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
		
func _on_card_clicked(card: BaseCard) -> void:
	if !input_enabled:
		return
	if card.selected:
		selected_cards.erase(card)
		card.set_selected(false)
	else:
		# Order matters.  Selected card order should match hand order
		var insert_idx = 0
		for i in cards.size():
			if cards[i] == card:
				insert_idx = i
				break
		var added = false
		for j in selected_cards.size():
			if cards.find(selected_cards[j]) > insert_idx:
				selected_cards.insert(j, card)
				added = true
				break
		if not added:
			selected_cards.append(card)
		card.set_selected(true)
	selected_cards_changed.emit(selected_cards)

func _on_card_released(card: BaseCard):
	if !input_enabled:
		return
	var nearest_index = _get_nearest_index(card.position.x)
	_reorder_card(card, nearest_index)
	layout_cards()

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

func _reorder_card(card: BaseCard, new_index: int):
	cards.erase(card)
	cards.insert(new_index, card)
	
func get_selected_card_data() -> Array[BaseCardData]:
	var result: Array[BaseCardData] = []
	for c in selected_cards:
		result.append(c.data as BaseCardData)
	return result
	
func remove_all(played_cards: Array[BaseCard], free_nodes: bool = true) -> void:
	selected_cards.clear()
	var remaining = played_cards.size()
	for card in played_cards:
		cards.erase(card)
		if free_nodes:
			var fade_tween = create_tween()
			fade_tween.tween_property(card, "modulate:a", 0.0, 0.3)
			fade_tween.finished.connect(func():
				remaining -= 1
				if remaining == 0:
					for c in played_cards:
						c.queue_free()
			)

func disable_input():
	input_enabled = false
	for card in cards:
		card.hand_input_enabled = false
		
func enable_input():
	input_enabled = true
	for card in cards:
		card.hand_input_enabled = true
		
func deselect_all() -> void:
	for card in selected_cards:
		card.set_selected(false)
	selected_cards.clear()
