class_name DissolveAndEmit 
extends Control

@export var duration = 1

@onready var card = $Card
@onready var particles = $Particles

func _ready() -> void:
	particles.visible = false
	await Animate.delay(1)
	dissolve()

func _process(delta: float) -> void:
	pass

func dissolve():
	var tween = create_tween()
	tween.tween_property(card.material, 'shader_parameter/dissolve_value', 0, duration)
	await Animate.delay(duration * .4)
	particles.visible = true

func update_radius(value: float):
	if card.material:
		card.material.set_shader_parameter("radius", value)
