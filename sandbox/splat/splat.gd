class_name Splat extends Node2D

@onready var burst = $Burst
@onready var drip = $Drip

func _ready():
	burst.emitting = false
	drip.emitting = false

func _process(delta):
	if Input.is_action_just_pressed("DEBUG"):
		play_once()
		
func play_once():
	burst_once()
	drip_once()
	
func burst_once():
	burst.emitting = true
	await get_tree().create_timer(burst.lifetime).timeout
	burst.emitting = false

func drip_once():
	await Animate.delay(0.15)
	drip.emitting = true
	await get_tree().create_timer(drip.lifetime).timeout
	drip.emitting = false
