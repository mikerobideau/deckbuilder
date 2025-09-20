class_name Table
extends Control

var cards: Array[Card] = []

func get_next_slot_position(index: int) -> Vector2:
	var card_width = cards[0].size.x if not cards.is_empty() else 100
	return global_position + Vector2(index * (card_width + 20), 0)

func layout_cards():
	for i in cards.size():
		var card = cards[i]
		card.position = Vector2(i * (card.size.x + 20), 0)
