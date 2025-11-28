class_name TargetManager
extends Node

signal selection_changed(selection: UnitCard)

var selection: UnitCard = null
var input_enabled: bool = true

func select(target: Node) -> void:
	if !input_enabled or not is_valid_target(target):
		return

	_deselect_current()
	if selection != target:
		selection = target
		_update_visuals()
		selection_changed.emit(selection)

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
		
func enable_input():
	input_enabled = true
	
func disable_input():
	input_enabled = false

func cleanup_reference(card: UnitCard):
	if selection == card:
		deselect()
