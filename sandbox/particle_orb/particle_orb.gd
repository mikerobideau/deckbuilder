class_name ParticleOrb 
extends Control

@onready var particles = $Particles
@onready var orb  = $Orb

func _ready() -> void:
	_configure()

func _process(delta: float) -> void:
	pass

func _configure():
	pass
	#pivot_offset = Vector2(size.x / 2, size.y / 2)
