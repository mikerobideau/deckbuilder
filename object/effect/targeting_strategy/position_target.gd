#TODO: Frontline/backline no longer exists on board. This needs to be updateds 

class_name PositionTarget
extends TargetingStrategy

enum Position { FRONTLINE, BACKLINE }

@export var position = Position.FRONTLINE

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	var board = context.board
	var row = board.get_row_of_unit(source)
	var index: int
	var front_unit: UnitCard
	
	if source is Hero or source is Item:
		var enemies = board.get_enemies_in_row(row)
		index = 0 if position == Position.FRONTLINE else enemies.size() - 1
		if enemies.size() == 0:
			return []
		else:
			front_unit = enemies[index]
	else:
		var heroes = board.get_heroes_in_row(row)
		index = heroes.size() - 1 if position == Position.FRONTLINE else 0
		if heroes.size() == 0:
			return []
		else:
			front_unit = heroes[index]
			
	return [front_unit]
		
