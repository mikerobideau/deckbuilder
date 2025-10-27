class_name Heart extends TextureRect

@export var health: int

@onready var counter = $MarginContainer/Counter

var color: Color
var flash_color_increase = Color.WHITE
var flash_color_decrease = Color.BLACK

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_configure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _configure():
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	color = modulate
	counter.speed = 0.2
	
func set_font_size(size: int):
	counter.set_font_size(size)
	
func set_health(new_value: int):
	
	if new_value == health:
		return
	var is_increase = true if new_value > health else false
	health = new_value
	if !counter.value:
		counter.set_default_value(new_value)
	else:
		counter.flip_to(new_value)
		if is_increase:
			animate_bounce_increase()
		else:
			animate_bounce_decrease()
			
func animate_bounce_increase():
	var scale_tween = create_tween()
	scale_tween.set_trans(scale_tween.TRANS_BOUNCE)
	
	#Increase scale
	scale_tween.tween_property(self, 'scale', Vector2(1.4, 1.4), 0.2)
	scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.2)
	
	#Modulate
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, 'self_modulate', flash_color_increase, 0.2)
	modulate_tween.tween_property(self, 'self_modulate', color, 0.2)
	
	#Shrink, squish, restore scale
	#scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.25), 0.2)
	#scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.1)
	#var bulge_tween = create_tween()
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.6, 0.2)
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.0, 0.1)
	await scale_tween.finished

func animate_bounce_decrease():
	var scale_tween = create_tween()
	scale_tween.set_trans(scale_tween.TRANS_BOUNCE)
	scale_tween.tween_property(self, 'scale', Vector2(0.6, 0.6), 0.2)
	scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.2)
	
	#Modulate
	var modulate_tween = create_tween()
	modulate_tween.tween_property(self, 'self_modulate', flash_color_decrease, 0.2)
	modulate_tween.tween_property(self, 'self_modulate', color, 0.2)
	
	await scale_tween.finished
