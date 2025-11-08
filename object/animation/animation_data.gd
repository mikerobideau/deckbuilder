class_name AnimationData
extends Resource

enum AnimationType { 
	JAB, 
	SHAKE,
	ATTACK
}

@export var animation_type: AnimationType

var duration = Const.ANIMATION_STEP

func play(node: Node) -> Signal:
	match animation_type:
		AnimationType.JAB:
			return Animate.jab(node)
		AnimationType.SHAKE:
			return Animate.shake(node)
		AnimationType.ATTACK:
			await Animate.attack(node)
			return Animate.retreat(node)
		_:
			return Animate.jab(node, duration)
