class_name SignalGroup
extends Node

signal finished()
var signal_count = -1
var signal_completed_count = 0

func _init(signals: Array[Signal]):
	signal_count = signals.size()
	for s in signals:
		s.connect(_on_signal_finished)
		
func _on_signal_finished():
	print_debug('Signal finished')
	if signal_count == -1:
		push_warning('Signal finished, but signal count not initialized')
		return
	signal_completed_count += 1
	if signal_count == signal_completed_count:
		print_debug('emitting')
		finished.emit()
