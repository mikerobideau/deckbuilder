class_name Projectile 
extends CharacterBody2D

@export var speed = -100

var spawn_position: Vector2
var spawn_rotation: float
var direction: float

func _ready() -> void:
	global_position = spawn_position
	global_rotation = spawn_rotation

func _physics_process(delta) -> void:
	velocity = Vector2(0, speed).rotated(direction)
	move_and_slide()
