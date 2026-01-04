class_name ControlBoard
extends Node2D

signal placement_confirmed(cell: Cell)
signal cell_clicked(cell: Cell)

enum ZoneType { HERO, CONTROL, ENEMY }

var CellScene = preload("res://object/control_board/cell.tscn")

const NUM_COLUMNS = Const.BOARD_COLUMNS
const NUM_ROWS = Const.BOARD_ROWS

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
				c * (Const.BOARD_CELL_SIZE.x + Const.BOARD_CELL_PADDING.x),
				r * (Const.BOARD_CELL_SIZE.y + Const.BOARD_CELL_PADDING.y)
			)
			cell.cell_clicked.connect(_on_cell_clicked)
			row_cells.append(cell)
		cells.append(row_cells)
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng

# ---- Placement ----

func begin_placement(allowed_zone: ZoneType) -> void:
	_placement_mode = true
	_allowed_zone = allowed_zone
	_highlight_valid_cells(true)
	_update_selected_visual(null)
	emit_signal("placement_started", allowed_zone)
	
func cancel_placement() -> void:
	if !_placement_mode: return
	_highlight_valid_cells(false)
	_placement_mode = false
	_update_selected_visual(null) 
	emit_signal("placement_cancelled")

func pick_cell_for_zone(allowed_zone: ZoneType) -> Cell:
	begin_placement(allowed_zone)
	var cell: Cell = await self.placement_confirmed
	_highlight_valid_cells(false)
	_placement_mode = false
	return cell

func _on_cell_clicked(cell: Cell) -> void:
	if _placement_mode:
		_on_cell_clicked_in_placement_mode(cell)
	cell_clicked.emit(cell)

func _on_cell_clicked_in_placement_mode(cell: Cell):
	if get_zone_type(cell.row, cell.column) != _allowed_zone: return
	if !cell.is_empty(): return
	_update_selected_visual(cell)
	_pending_cell = cell
	emit_signal("placement_confirmed", cell)
	
func _on_cell_clicked_in_move_mode(cell: Cell):
	pass

func place_board_object(board_object: BaseCard, row: int, column: int) -> void:
	if row < 0 or row >= NUM_ROWS or column < 0 or column >= NUM_COLUMNS:
		push_warning("place_board_object: out of bounds (%s,%s)" % [row, column])
		return
	var cell = cells[row][column]
	if not cell.is_empty():
		push_warning("place_board_object: cell (%s,%s) is occupied." % [row, column])
		return
	cell.place_card(board_object, true)

func place_unit(unit_node: BaseCard, row: int, column: int) -> void:
	if row < 0 or row >= NUM_ROWS or column < 0 or column >= NUM_COLUMNS:
		push_warning("place_unit: out of bounds (%s,%s)" % [row, column])
		return
	var cell = cells[row][column]
	if not cell.is_empty():
		push_warning("place_unit: cell (%s,%s) is occupied." % [row, column])
		return
	cell.place_card(unit_node)

func place_unit_on_cell(unit_node: UnitCard, cell: Cell) -> void:
	place_unit(unit_node, cell.row, cell.column)

# ---- Move / Remove----

func move_unit(unit_node: UnitCard, new_row: int, new_column: int) -> void:
	for row_cells in cells:
		for cell in row_cells:
			if cell.card == unit_node:
				cell.remove_card_reference()
				break
	cells[new_row][new_column].place_card(unit_node)

func move_unit_to_front(unit: UnitCard):
	var front_index = (NUM_COLUMNS / 2) - 1 if unit is Hero else NUM_COLUMNS / 2
	var cell = get_cell_of_unit(unit)

	var bump_direction = -1 if unit is Hero else 1
	_bump_units_back(cell.row, front_index, bump_direction)
	
	if !unit:
		print_debug('trying to move unit to front, but it is null')
	move_unit(unit, cell.row, front_index)

func _bump_units_back(row: int, start_column: int, direction: int) -> void:
	# Ensure index stays on board
	if start_column < 0 or start_column >= NUM_COLUMNS:
		return

	var cell = cells[row][start_column]
	if cell.is_empty():
		return  # No one to bump

	var next_col = start_column + direction
	if next_col < 0 or next_col >= NUM_COLUMNS:
		return  # Can't bump further, end of row reached

	# Recurse: bump next unit first if occupied
	_bump_units_back(row, next_col, direction)

	# Move current unit one step back
	move_unit(cell.unit, row, next_col)

func remove_card_reference(unit_node: UnitCard) -> void:
	for row_cells in cells:
		for cell in row_cells:
			if cell.unit == unit_node:
				cell.remove_card_reference()
				break

# ---- Iteration ----
func for_each_cell(callback: Callable) -> void:
	for r in range(NUM_ROWS):
		for c in range(NUM_COLUMNS):
			callback.call(cells[r][c], r, c)

# ---- Getters ----
			
func get_units_in_row(row: int) -> Array[UnitCard]:
	var result = []
	for cell in cells[row]:
		if not cell.is_empty():
			result.append(cell.unit)
	return result
	
func get_cell_of_unit(unit: UnitCard) -> Cell:
	for r in range(NUM_ROWS):
		for cell in cells[r]:
			if cell.card == unit:
				return cell
	return null
	
func get_row_of_unit(unit: UnitCard) -> int:
	for r in range(NUM_ROWS):
		for cell in cells[r]:
			if cell.unit == unit:
				return r
	return -1
	
func get_enemies_in_row(row: int) -> Array[Enemy]:
	var result: Array[Enemy] = []
	for cell in cells[row]:
		if cell.unit is Enemy:
			result.append(cell.unit)
	return result

func get_heroes_in_row(row: int) -> Array[Hero]:
	var result: Array[Hero] = []
	for cell in cells[row]:
		if cell.unit is Hero:
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
			if get_zone_type(cell.row, cell.column) == zone and not cell.is_empty():
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
	
func get_splash_targets(primary_target: UnitCard) -> Array[UnitCard]:
	var cell = get_cell_of_unit(primary_target)
	var result: Array[UnitCard] = []
	
	if primary_target is Enemy:
		for enemy in get_enemies_in_row(cell.row):
			var enemy_cell = get_cell_of_unit(enemy)
			if enemy_cell.column > cell.column:
				result.append(enemy)
				
	if primary_target is Hero:
		for hero in get_heroes_in_row(cell.row):
			var hero_cell = get_cell_of_unit(hero)
			if hero_cell.column < cell.column:
				result.append(hero)
				
	return result

# ---- Board layout ----
	
func get_zone_type(row: int, column: int = -1) -> ZoneType:
	if row <= 1:
		return ZoneType.ENEMY
	if row >= 2:
		return ZoneType.HERO
	return ZoneType.CONTROL

func get_empty_cells_in_zone(zone: ZoneType) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	for r in range(cells.size()):
		for c in range(cells[r].size()):
			if get_zone_type(r, c) == zone and cells[r][c].is_empty():
				out.append(Vector2i(r, c))
	return out

func get_size():
	return Vector2(
		NUM_COLUMNS * (Const.BOARD_CELL_SIZE.x + Const.BOARD_CELL_PADDING.x),
		NUM_ROWS * (Const.BOARD_CELL_SIZE.y + Const.BOARD_CELL_PADDING.y)
	)

# ---- Visual helpers ----

func _highlight_valid_cells(enabled: bool) -> void:
	for row_cells in cells:
		for cell in row_cells:
			var valid = enabled and cell.is_empty() and get_zone_type(cell.row, cell.column) == _allowed_zone
			cell.set_zone_highlight(valid)
			
func _update_selected_visual(new_selected: Cell) -> void:
	if _pending_cell and is_instance_valid(_pending_cell):
		_pending_cell.set_selected(false)

	_pending_cell = new_selected
	if new_selected:
		new_selected.set_selected(true)

func clear_move_highlights() -> void:
	for_each_cell(func(cell, r, c):
		cell.set_zone_highlight(false)
	)

func highlight_move_cells(cells_to_mark: Array[Cell]) -> void:
	clear_move_highlights()
	for cell in cells_to_mark:
		cell.set_zone_highlight(true)


# ---- Debug

func debug_unit_state(unit: UnitCard, label: String):
	if unit == null:
		print("DEBUG:", label, "unit = NULL")
		return
	
	var parent_name =  unit.get_parent().name if unit.get_parent() != null else "null"
	var pos = unit.global_position
	var vis = unit.visible

	var cell = get_cell_of_unit(unit)
	var cell_str =  "NONE" if cell == null else "%s,%s" % [cell.row, cell.column]

	print("\n===== DEBUG:", label, "=====")
	print(" Unit:", unit.name, " @ ", pos)
	print(" Parent:", parent_name)
	print(" Visible:", vis)
	print(" Cell:", cell_str)
	print(" Freed:", is_instance_valid(unit)) # true = OK
	print("==============================\n")
