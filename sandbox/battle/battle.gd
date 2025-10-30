class_name Battle
extends Node2D

@onready var board = $Board
@onready var hand = $MockHand

var ProjectileArc = preload("res://sandbox/projectile_arc/projectile_arc.tscn")
var Splat = preload("res://sandbox/splat/splat.tscn")

var card_generator: CardGenerator
var enemy_generator: EnemyGenerator
var rng: RandomNumberGenerator
var hero: Hero
var enemy: Enemy
var item: Item

func _ready():
	rng = RandomNumberGenerator.new()
	card_generator = CardGenerator.new(rng)
	enemy_generator = EnemyGenerator.new(rng)
	setup_board()
	setup_hand()

func _process(delta):
	if Input.is_action_just_pressed("Debug1"):
		attack()
	if Input.is_action_just_pressed("Debug2"):
		launch_tag()
	if Input.is_action_just_pressed("Debug3"):
		apply_item()

func setup_board():
	hero = card_generator.generate_hero()
	enemy = enemy_generator.generate()
	board.place_unit(hero, 1, 2)
	board.place_unit(enemy, 1, 4)	
	
func setup_hand():
	item = card_generator.generate_item()
	hand.add_child(item)
	
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
	
func apply_item():
	var x = hero.global_position.x
	var y = hero.global_position.y + hero.size.y + 10
	await item.move(Vector2(x, y))
	await Animate.delay(0.2)
	item.dissolve(Color.DEEP_PINK)
	await Animate.delay(0.1)
	hero.flash(Color.DEEP_PINK, 1.0)
	hero.shake(1.0)
	
func play_splat(pos: Vector2):
	var splat = Splat.instantiate()
	add_child(splat)
	splat.position = pos
	await splat.play_once()
	
