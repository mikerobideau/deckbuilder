class_name AnimationGlobal
extends Node

func delay():
	await get_tree().create_timer(Const.ANIMATION_DELAY).timeout
