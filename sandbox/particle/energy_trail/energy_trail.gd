class_name EnergyTrail extends Node2D

@onready var particles = $Particles

func _ready() -> void:
	particles.emitting = false

func _process(delta: float) -> void:
	pass
	
func play():
	particles.emitting = true
	
func stop():
	particles.emitting = false
