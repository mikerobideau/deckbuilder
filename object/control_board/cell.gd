class_name Cell
extends ColorRect

signal cell_clicked(cell: Cell)

var row: int
var column: int
var unit: UnitCard = null
var _is_selected := false
var _is_zone_highlight := false

const SIZE = Const.CARD_SIZE

func place_unit(unit_card: UnitCard) -> void:
	if unit:
		unit.queue_free()
	unit = unit_card

	# Remove from current parent first
	if unit_card.get_parent():
		unit_card.get_parent().remove_child(unit_card)

	# Add to this cell
	add_child(unit_card)

	# Align visually to this cell’s position in the world
	unit_card.global_position = global_position

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

func _on_gui_input(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		emit_signal("cell_clicked", self)

# ---------- Visuals ----------
# Called by board to indicate "valid candidate in zone"
func set_zone_highlight(on: bool) -> void:
	_is_zone_highlight = on
	_update_visual()

# Called by board to indicate "this is the chosen/pending cell"
func set_selected(on: bool) -> void:
	_is_selected = on
	_update_visual()

func _update_visual() -> void:
	# Order of precedence: selected > zone-highlight > default
	if _is_selected:
		# Selected/pending: saturated green tint
		modulate = Color(0.55, 1.0, 0.6, 1.0)
	elif _is_zone_highlight:
		# In-zone candidate: soft teal
		modulate = Color(0.7, 0.95, 1.0, 1.0)
	else:
		# Default
		modulate = Color(1, 1, 1, 1)
