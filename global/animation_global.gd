class_name AnimationGlobal
extends Node

func delay(length: float = Const.ANIMATION_DELAY):
	await get_tree().create_timer(length).timeout

func await_all(list: Array):
	var counter = { value = list.size() }
	for el in list:
		if el is Signal:
			el.connect(count_down.bind(counter), CONNECT_ONE_SHOT)
		elif el is Callable:
			# Wrap Callable to ensure it's awaited and then counted down
			func_wrapper(el, count_down.bind(counter))
	
	# Wait until all elements have counted down
	while counter.value > 0:
		await get_tree().process_frame

func count_down(dict):
	dict.value -= 1

func func_wrapper(call: Callable, call_back: Callable):
	await call.call()
	call_back.call()
