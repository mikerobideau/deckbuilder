class_name TweenGroup
extends Node

signal finished()
var tween_count = -1
var tween_completed_count = 0

func _init(tweens: Array[Tween]):
	tween_count = tweens.size()
	for tween in tweens:
		tween.finished.connect(_on_tween_finished)
		
func _on_tween_finished():
	print_debug('Tween finished')
	if tween_count == -1:
		push_warning('Tween finished, but tween count not initialized')
		return
	tween_completed_count += 1
	if tween_count == tween_completed_count:
		print_debug('emitting')
		finished.emit()
