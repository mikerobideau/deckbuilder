class_name HeartDemo 
extends Control

@onready var heart = $Heart

func _ready() -> void:
	call_deferred('start')

func _process(delta: float) -> void:
	pass

func start():
	heart.set_font_size(14)
	heart.set_health(7)
	for i in [6, 8, 3]:
		await Animate.delay(1)
		heart.set_health(i)
