class_name AnimationGlobal
extends Node

func delay(length: float = Const.ANIMATION_DELAY):
	await get_tree().create_timer(length).timeout
