class_name Splat extends Node2D

@onready var burst = $Burst
@onready var drip = $Drip

func _ready():
	burst.visible = false
	burst.emitting = false
	drip.visible = false
	drip.emitting = false

#func _process(delta):
#	if Input.is_action_just_pressed("DEBUG"):
#		play_once()
		
func play_once():
	burst_once()
	drip_once()
	
func burst_once():
	burst.visible = true
	burst.emitting = true
	var tween = create_tween()
	tween.tween_property(burst, 'modulate:a', 0, burst.lifetime)
	await get_tree().create_timer(burst.lifetime).timeout
	burst.queue_free()

func drip_once():
	await Animate.delay(0.1)
	drip.visible = true
	drip.emitting = true
	var tween = create_tween()
	tween.tween_property(drip, 'modulate:a', 0, drip.lifetime)
	await get_tree().create_timer(drip.lifetime).timeout
	drip.queue_free()
