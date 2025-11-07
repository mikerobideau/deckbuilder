class_name AnimationData
extends Resource

enum AnimationType { 
	JAB, 
	SHAKE 
}

@export var animation_type: AnimationType

var duration = Const.ANIMATION_STEP / 2

func play(node: Node) -> Signal:
	match animation_type:
		AnimationType.JAB:
			return Animate.jab(node)
		_:
			return Animate.jab(node, duration)
