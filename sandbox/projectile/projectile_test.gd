class_name ProjectileTest
extends Node2D

@onready var main = get_tree().get_root().get_node('Main')
@onready var ProjectileScene = load("res://sandbox/projectile/projectile.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func shoot():
	var projectile = ProjectileScene.instantiate()
	projectile.direction = rotation
	projectile.spawn_position = global_position
	projectile.spawn_rotation = rotation
	main.add_child.call_deferred(projectile)
