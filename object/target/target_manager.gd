class_name TargetManager
extends Node

var selection: UnitCard = null

func select(target: Node) -> void:
	if not is_valid_target(target):
		return

	if selection == target:
		_deselect_current()
		return

	_deselect_current()
	selection = target
	_update_visuals()

func deselect() -> void:
	_deselect_current()

func _deselect_current():
	if selection:
		selection.set_highlighted(false)
		selection = null

func is_valid_target(target: Node) -> bool:
	return target is UnitCard and target.is_location_garden()

func _update_visuals():
	if selection:
		selection.set_highlighted(true)
