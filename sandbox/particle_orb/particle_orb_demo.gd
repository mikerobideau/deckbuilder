extends Control

@onready var orb = $Panel/Orb

func _ready() -> void:
	await Animate.delay(1)
	await orb.on_for(Color.DARK_BLUE, Color.SKY_BLUE, 2)
	await orb.on_for(Color.DEEP_PINK, Color.HOT_PINK, 2)
	await orb.on_for(Color.ORANGE_RED, Color.ORANGE, 2)

func _process(delta: float) -> void:
	pass
