class_name Cell
extends ColorRect

var row: int
var column: int
var unit: UnitCard = null

const SIZE = Const.CARD_SIZE

func place_unit(unit_card: UnitCard) -> void:
	if unit:
		unit.queue_free()
	unit = unit_card
	add_child(unit_card)
	unit_card.position = Vector2(0, 0)

func remove_unit() -> void:
	if unit:
		unit.queue_free()
		unit = null

func is_empty() -> bool:
	return unit == null

func is_occupied_by_hero() -> bool:
	return unit is Hero

func is_occupied_by_enemy() -> bool:
	return unit is Enemy
