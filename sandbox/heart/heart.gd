class_name Heart 
extends Control

signal set_health_completed()

@export var health: int

@onready var counter = $Counter
@onready var icon = $Icon

var color = Color.HOT_PINK
var flash_color_increase = Color.WHITE
var flash_color_decrease = Color.BLACK
var scale_normal = Vector2(1.0, 1.0)
var scale_large = Vector2(1.25, 1.25)
var scale_small = Vector2(0.75, 0.75)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_configure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _configure():
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	icon.modulate = color
	#scale = scale_normal
	
func set_font_size(size: int):
	counter.set_font_size(size)
	
func set_health(new_value: int) -> Signal:
	if new_value == health:
		set_health_completed.emit()
		return set_health_completed
	var is_increase = true if new_value > health else false
	health = new_value
	counter.set_default_value(new_value)
	set_health_completed.emit()
	return set_health_completed
	
func _instant_signal() -> Signal:
	var dummy := RefCounted.new()
	dummy.add_user_signal("finished")
	dummy.emit_signal("finished")
	return dummy.finished
			
func animate_bounce_increase():
	var scale_tween = create_tween()
	scale_tween.set_trans(scale_tween.TRANS_BOUNCE)
	
	#Increase scale
	scale_tween.tween_property(icon, 'scale', scale_large, 0.2)
	scale_tween.tween_property(icon, 'scale', scale_normal, 0.2)
	
	#Modulate
	var modulate_tween = create_tween()
	modulate_tween.tween_property(icon, 'self_modulate', flash_color_increase, 0.2)
	modulate_tween.tween_property(icon, 'self_modulate', color, 0.2)
	
	#Shrink, squish, restore scale
	#scale_tween.tween_property(icon, 'scale', Vector2(1.0, 1.25), 0.2)
	#scale_tween.tween_property(icon, 'scale', Vector2(1.0, 1.0), 0.1)
	#var bulge_tween = create_tween()
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.6, 0.2)
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.0, 0.1)
	await scale_tween.finished

func animate_bounce_decrease():
	var scale_tween = create_tween()
	scale_tween.set_trans(scale_tween.TRANS_BOUNCE)
	scale_tween.tween_property(icon, 'scale', scale_small, 0.2)
	scale_tween.tween_property(icon, 'scale', scale_large, 0.2)
	
	#Modulate
	var modulate_tween = create_tween()
	modulate_tween.tween_property(icon, 'self_modulate', flash_color_decrease, 0.2)
	modulate_tween.tween_property(icon, 'self_modulate', color, 0.2)
	
	await scale_tween.finished
