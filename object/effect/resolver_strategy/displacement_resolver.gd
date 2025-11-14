class_name DisplacementResolver
extends ResolverStrategy

enum Position { FRONTLINE, BACKLINE }

@export var position: Position

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData):
	#only supports single target
	if targets.size() != 1:
		return
		
	var target = targets[0]
	
	if animation:
		animation.play(source)
		
		if position == Position.FRONTLINE:
			context.board.move_unit_to_front(target)
