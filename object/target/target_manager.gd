class_name TargetManager
extends Node

var selection: Node = null

func select(target: Node) -> void:
	if !is_valid_target(target):
		return
	if selection:
		selection.set_selected(false)
	if selection == target:
		selection = null
	else:
		selection = target
		selection.set_selected(true)

func deselect():
	if selection:
		selection.set_selected(false)
		selection = null

func is_valid_target(target: Node) -> bool:
	if target is UnitCard and target.is_location_hand():
		return false
	return true
