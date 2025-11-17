class_name AttackCardDemo
extends Control

@onready var card1 = $Card1Container/Card1
@onready var card2 = $Card2Container/Card2

func _ready() -> void:
	await Animate.delay(1)
	var target_position = card2.global_position
	card1.attack(target_position)

func _process(delta: float) -> void:
	pass
