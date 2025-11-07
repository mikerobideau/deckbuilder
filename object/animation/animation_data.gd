class_name AnimationData
extends Resource

enum AnimationType { 
	JAB, 
	SHAKE 
}

@export var animation_type: AnimationType

var duration = Const.ANIMATION_STEP

func play(node: Node) -> Signal:
	match animation_type:
		AnimationType.JAB:
			return Animate.jab(node)
		AnimationType.SHAKE:
			return Animate.shake(node)
		_:
			return Animate.jab(node, duration)
