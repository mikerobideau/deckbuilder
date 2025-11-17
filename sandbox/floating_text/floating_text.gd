class_name FloatingText 
extends Control

@onready var label = $Label

@export var text: String
@export var color = Color.WHITE
@export var duration = Const.ANIMATION_STEP * 2

func _ready() -> void:
	if label:
		label.text = text
		_configure()

func _process(delta: float) -> void:
	pass
	
func _configure():
	label.add_theme_color_override("font_color", color)

func set_text(new_text: String):
	text = new_text
	label.text = text
	
func play() -> Signal:
	visible = true
	var t1 = expand()
	var t2 = fade()
	t1.finished.connect(func(): t2.play())
	return t2.finished

func expand():
	label.size = label.get_minimum_size()
	label.pivot_offset = label.size * 0.5
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(label, "scale", Vector2(5, 5), duration)
	return tween
	
func fade():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate:a", 0, duration)
	return tween

func cleanup():
	visible = false
	label.scale = Vector2(1, 1)
	modulate.a = 1
