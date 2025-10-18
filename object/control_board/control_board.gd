class_name ControlBoard
extends Node

enum ZoneType { HERO, CONTROL, ENEMY }

var CellScene = preload("res://object/control_board/cell.tscn")

const NUM_COLUMNS = 5
const NUM_ROWS = 3
const PADDING = Vector2(50, 50)

var grid: Array = []
var rows: int = NUM_ROWS

var cells: Array = [] # 2D array: cells[row][column] = Cell node

func _ready() -> void:
	print_debug('Cells _ready called')
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
			row_cells.append(cell)
		cells.append(row_cells)
	
	print_debug('Board ready emitted()')
		
func get_zone_type(column: int) -> ZoneType:
	if column <= 1:
		return ZoneType.HERO
	elif column == 2:
		return ZoneType.CONTROL
	else:
		return ZoneType.ENEMY

func place_unit(unit_node: UnitCard, row: int, column: int) -> void:
	print_debug('Attemping to place unit.  Cells has size ' + str(cells.size()))
	var cell = cells[row][column]
	cell.place_unit(unit_node)

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

func get_heroes() -> Array[Hero]:
	var result: Array[Hero] = []
	for row in cells:
		for cell in row:
			if cell.unit is Hero:
				result.append(cell.unit)
	return result

func get_enemies() -> Array[Enemy]:
	var result: Array[Enemy] = []
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
