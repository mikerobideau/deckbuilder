class_name Card
extends Control

@onready var background = $Background
@onready var floating_text = $FloatingText
@onready var orb = $Bottom/Orb
@onready var heart = $Heart

var shake_angle = 5.0
var default_color: Color

func _ready() -> void:
	heart.set_health(7)
	default_color = modulate
	_configure()

func _process(delta: float) -> void:
	pass
	
func _configure():
	pivot_offset = Vector2(size.x / 2, size.y / 2)

func _on_gui_input(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		heart.set_health(8)
		#flash(Color.DEEP_PINK)
		#shake()
		#play_floating_text("25")
		#activate_ability()
	
func activate_ability():
	orb.on_for(Color.DEEP_PINK, Color.HOT_PINK, Const.ANIMATION_STEP * 3)
		
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
