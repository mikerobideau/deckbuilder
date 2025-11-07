class_name AnimationGlobal
extends Node

func delay(length: float = Const.ANIMATION_DELAY):
	await get_tree().create_timer(length).timeout
	
func chain(signals: Array[Signal]):
	await SignalGroup.new(signals).finished
	
func shake(node: Node, shake_angle = 5.0, duration = Const.ANIMATION_STEP):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "rotation_degrees", -shake_angle, duration)
	tween.tween_property(node, "rotation_degrees", shake_angle, duration)
	tween.tween_property(node, "rotation_degrees", 0, duration)
	return tween.finished
	
func flash(node: Node, color: Color, duration = Const.ANIMATION_STEP):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(node, "modulate", color, duration / 2)
	tween.tween_property(node, "modulate", Const.CARD_COLOR, duration / 2)
	return tween.finished

func move(node: Node, target: Vector2, duration = Const.ANIMATION_STEP):
	var tween = create_tween()
	tween.tween_property(node, 'global_position', target, duration)
	return tween
