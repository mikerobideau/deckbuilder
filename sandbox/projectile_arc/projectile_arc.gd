class_name ProjectileArc
extends Node2D

@onready var projectile = $Projectile

@export var direction = Vector2(5, 0)
@export var distance = 300
@export var angle = 60

var initial_speed: float
var throw_angle_degrees: float
var gravity: float = 100
var time: float = 0.0
var initial_position: Vector2
var normalized_direction: Vector2
var z_axis = 0.0 #simulated z axis
var is_launch: bool = false
var time_mult: float = 6.0

func _process(delta):
	time += delta * time_mult
	
	if Input.is_action_just_pressed("DEBUG"):
		launch()
		
	if is_launch:
		z_axis = initial_speed * sin(deg_to_rad(throw_angle_degrees)) * time - 0.5 * gravity * pow(time, 2)
		
		if z_axis > 0:
			var x_axis: float = initial_speed * cos(deg_to_rad(throw_angle_degrees)) * time
			global_position = initial_position + normalized_direction * x_axis # Move everything along the 'x-axis'
			projectile.position.y = -z_axis # Move only the projectile along the y axis based on the simulated z-axis
		
func launch():
	_launch_projectile(global_position, direction, distance, angle)
		
func _launch_projectile(initial_pos: Vector2, dir: Vector2, desired_distance: float, desired_angle_deg: float):
	initial_position = initial_pos
	normalized_direction = dir.normalized()
	throw_angle_degrees = desired_angle_deg
	initial_speed = pow(desired_distance * gravity / sin(2 * deg_to_rad(desired_angle_deg)), 0.5)
	global_position = initial_position
	time = 0.0
	z_axis = 0
	is_launch = true
	
