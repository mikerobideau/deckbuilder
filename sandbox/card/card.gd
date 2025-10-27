class_name Card
extends Control

@onready var background = $Background
@onready var floating_text = $FloatingText

@export var shake_angle = 5.0 # degrees of rotation (adjust for more/less shake)
var default_color: Color

func _ready() -> void:
	default_color = modulate
	_configure()

func _process(delta: float) -> void:
	pass
	
func _configure():
	pivot_offset = Vector2(size.x / 2, size.y / 2)

func _on_gui_input(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		flash(Color.GREEN)
		shake()
		play_floating_text("+1")
		
func shake():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "rotation_degrees", -shake_angle, Const.ANIMATION_STEP / 2)
	tween.tween_property(self, "rotation_degrees", shake_angle, Const.ANIMATION_STEP)
	tween.tween_property(self, "rotation_degrees", 0, Const.ANIMATION_STEP / 2)
	
func flash(color: Color):
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "modulate", color, Const.ANIMATION_STEP)
	tween.tween_property(self, "modulate", default_color, Const.ANIMATION_STEP)
	
func play_floating_text(text: String):
	floating_text.set_text(text)
	floating_text.play()
