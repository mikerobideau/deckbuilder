class_name ControlBoard
extends Node2D

signal placement_confirmed(cell: Cell)

enum ZoneType { HERO, CONTROL, ENEMY }

var CellScene = preload("res://object/control_board/cell.tscn")

const NUM_COLUMNS = 6
const NUM_ROWS = 2
const PADDING = Vector2(50, 50)

var rng: RandomNumberGenerator
var grid: Array = []
var rows: int = NUM_ROWS
var cells: Array = [] # 2D array: cells[row][column] = Cell node
var _placement_mode: bool = false
var _allowed_zone: ZoneType = ZoneType.HERO
var _pending_cell: Cell = null

func _ready() -> void:
	cells.clear()
	for r in range(rows):
		var row_cells: Array = []
		for c in range(NUM_COLUMNS):
			var cell = CellScene.instantiate() as Cell
			cell.row = r
			cell.column = c
			add_child(cell)
			cell.position = Vector2(
				c * (Cell.SIZE.x + PADDING.x),
				r * (Cell.SIZE.y + PADDING.y)
			)
			cell.cell_clicked.connect(_on_cell_clicked)
			row_cells.append(cell)
		cells.append(row_cells)
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng

## Call to start a user placement interaction. Highlights valid cells.
func begin_placement(allowed_zone: ZoneType) -> void:
	_placement_mode = true
	_allowed_zone = allowed_zone
	_highlight_valid_cells(true)
	_update_selected_visual(null)
	emit_signal("placement_started", allowed_zone)

## Cancel placement (e.g., ESC).
func cancel_placement() -> void:
	if !_placement_mode: return
	_highlight_valid_cells(false)
	_placement_mode = false
	_update_selected_visual(null) 
	emit_signal("placement_cancelled")

## Await this from Round to get a chosen cell (convenience wrapper).
func pick_cell_for_zone(allowed_zone: ZoneType) -> Cell:
	begin_placement(allowed_zone)
	var cell: Cell = await self.placement_confirmed
	_highlight_valid_cells(false)
	_placement_mode = false
	return cell

func _on_cell_clicked(cell: Cell) -> void:
	if !_placement_mode: return
	if get_zone_type(cell.column) != _allowed_zone: return
	if !cell.is_empty(): return
	_update_selected_visual(cell)
	_pending_cell = cell
	emit_signal("placement_confirmed", cell)

func place_unit(unit_node: UnitCard, row: int, column: int) -> void:
	var cell = cells[row][column]
	if !cell.is_empty():
		push_warning("Cell (%s,%s) is occupied." % [row, column])
		return
	cell.place_unit(unit_node)

func place_unit_on_cell(unit_node: UnitCard, cell: Cell) -> void:
	place_unit(unit_node, cell.row, cell.column)

func move_unit(unit_node: UnitCard, new_row: int, new_column: int) -> void:
	# Find current cell
	for row_cells in cells:
		for cell in row_cells:
			if cell.unit == unit_node:
				cell.remove_unit()
				break
	cells[new_row][new_column].place_unit(unit_node)

func get_units_in_row(row: int) -> Array[UnitCard]:
	var result = []
	for cell in cells[row]:
		if not cell.is_empty():
			result.append(cell.unit)
	return result

func get_units_in_column(column: int) -> Array[UnitCard]:
	var result = []
	for r in range(rows):
		var cell = cells[r][column]
		if not cell.is_empty():
			result.append(cell.unit)
	return result
	
func get_units_by_zone(zone: ZoneType) -> Array[UnitCard]:
	var result = []
	for row_cells in cells:
		for cell in row_cells:
			if get_zone_type(cell.column) == zone and not cell.is_empty():
				result.append(cell.unit)
	return result

func get_heroes() -> Array[UnitCard]:
	var result: Array[UnitCard] = []
	for row in cells:
		for cell in row:
			if cell.unit is Hero:
				result.append(cell.unit)
	return result

func get_enemies() -> Array[UnitCard]:
	var result: Array[UnitCard] = []
	for row in cells:
		for cell in row:
			if cell.unit is Enemy:
				result.append(cell.unit)
	return result

func get_allies(unit: UnitCard) -> Array[UnitCard]:
	if unit is Hero:
		return get_heroes().filter(func(u): return u != unit)
	elif unit is Enemy:
		return get_enemies().filter(func(u): return u != unit)
	else:
		return []

func get_all_units() -> Array[UnitCard]:
	var result: Array[UnitCard] = []
	for row in cells:
		for cell in row:
			if cell.unit:
				result.append(cell.unit)
	return result

func get_size():
	return Vector2(
		NUM_COLUMNS * (Cell.SIZE.x + PADDING.x),
		NUM_ROWS * (Cell.SIZE.y + PADDING.y)
	)
	
func get_zone_type(column: int) -> ZoneType:
	if column <= 2:
		return ZoneType.HERO
	else:
		return ZoneType.ENEMY

# ---- Visual helpers ----
func _highlight_valid_cells(enabled: bool) -> void:
	for row_cells in cells:
		for cell in row_cells:
			var valid = enabled and cell.is_empty() and get_zone_type(cell.column) == _allowed_zone
			cell.set_zone_highlight(valid)
			
func _update_selected_visual(new_selected: Cell) -> void:
	if _pending_cell and is_instance_valid(_pending_cell):
		_pending_cell.set_selected(false)

	_pending_cell = new_selected
	if new_selected:
		new_selected.set_selected(true)
