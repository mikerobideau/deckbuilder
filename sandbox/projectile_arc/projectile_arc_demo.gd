class_name ArcProjectileDemo
extends Node2D

@onready var board = $Board

var ProjectileArc = preload("res://sandbox/projectile_arc/projectile_arc.tscn")
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
	await Animate.delay(1)
	launch_tag()
	
func setup_board():
	hero = card_generator.generate_hero()
	enemy = enemy_generator.generate()
	board.place_unit(hero, 1, 2)
	board.place_unit(enemy, 0, 3)	
	
func launch_tag():
	var projectile = ProjectileArc.instantiate()
	
	var offset = Vector2(64, 64)
	var spawn_position = hero.global_position + offset
	var enemy_position = enemy.global_position + offset
	
	projectile.spawn_position = spawn_position
	add_child(projectile)
	await Animate.delay(1)
	
	projectile.angle = 70
	projectile.direction = enemy_position - spawn_position
	projectile.distance = enemy_position.x - spawn_position.x
	projectile.launch()
