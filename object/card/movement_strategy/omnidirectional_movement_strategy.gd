class_name OmnidirectionalMovementStrategy
extends MovementStrategy

func get_valid_moves(context: MovementContext) -> Array[Cell]:
	var board = context.board
	var unit = context.unit
	var moves: Array[Cell] = []
	var cell_from = board.get_cell_of_unit(unit)

	var r0 = cell_from.row
	var c0 = cell_from.column

	board.for_each_cell(func(cell_to: Cell, r: int, c: int):
		if r == r0 and c == c0: #current cell
			return
	
		if abs(r - r0) <= 1 and abs(c - c0) <= 1:
			moves.append(cell_to)
	)

	return moves
