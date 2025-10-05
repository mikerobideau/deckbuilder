class_name TargetManager
extends Node

var selection: UnitCard = null

func select(target: Node) -> void:
	print_debug('processing selection')
	if not is_valid_target(target):
		print_debug('invalid target')
		return

	if selection == target:
		print_debug('Deselecting')
		_deselect_current()
		return

	_deselect_current()
	print_debug('Selecting')
	selection = target
	_update_visuals()

func deselect() -> void:
	_deselect_current()

func _deselect_current():
	if selection:
		selection.set_highlighted(false)
		selection = null

func is_valid_target(target: Node) -> bool:
	return target is UnitCard and target.is_location_board()

func _update_visuals():
	if selection:
		selection.set_highlighted(true)
