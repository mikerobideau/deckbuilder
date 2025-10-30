class_name Battle
extends Node2D

@onready var board = $Board

var ProjectileArc = preload("res://sandbox/projectile_arc/projectile_arc.tscn")
var Splat = preload("res://sandbox/splat/splat.tscn")

var card_generator: CardGenerator
var enemy_generator: EnemyGenerator
var rng: RandomNumberGenerator
var hero: Hero
var enemy: Enemy

func _ready():
	rng = RandomNumberGenerator.new()
	card_generator = CardGenerator.new(rng)
	enemy_generator = EnemyGenerator.new(rng)
	setup_board()

func _process(delta):
	if Input.is_action_just_pressed("Debug1"):
		attack()
	if Input.is_action_just_pressed("Debug2"):
		launch_tag()
	if Input.is_action_just_pressed("Debug3"):
		pass	

func setup_board():
	hero = card_generator.generate_hero()
	enemy = enemy_generator.generate()
	board.place_unit(hero, 1, 2)
	board.place_unit(enemy, 1, 4)	
	
func attack():
	var start_position = hero.global_position
	await hero.animate_attack(enemy.global_position)
	enemy.take_damage(1)
	hero.animate_retreat(start_position)
	
func launch_tag():
	var projectile = ProjectileArc.instantiate()
	
	var offset_start = Vector2(90, 120)
	var offset_end = Vector2(90, 120)
	var spawn_position = hero.global_position + offset_start
	var enemy_position = enemy.global_position + offset_end
	
	projectile.spawn_position = spawn_position
	add_child(projectile)

	projectile.angle = 70
	projectile.direction = enemy_position - spawn_position
	projectile.distance = enemy_position.x - spawn_position.x
	await projectile.launch()
	projectile.queue_free()
	
	play_splat(projectile.global_position)
	enemy.take_damage(1)
	
func play_splat(pos: Vector2):
	var splat = Splat.instantiate()
	add_child(splat)
	splat.position = pos
	await splat.play_once()
	
