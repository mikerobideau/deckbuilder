class_name Counter
extends CenterContainer

@export var speed = Const.ANIMATION_STEP

@onready var label_next = $LabelNext
@onready var label_current = $LabelCurrent

@export var value = 0
@export var font_size = 14
@export var height = 20
@export var width = 20

func _ready() -> void:
	size = get_parent().size
	setup()
	set_default_value(value)
	
func setup():
	set_font_size(font_size)
	
func set_default_value(new_value: int):
	value = new_value
	label_current.text = str(value)
	label_current.visible = true
	label_next.visible = false
	if value == null:
		push_warning("Counter should be initialized with a value")
	size.y = height
	size.x = width

func set_font_size(new_font_size: int):
	font_size = new_font_size
	configure_label(label_current)
	configure_label(label_next)
	
func configure_label(label: Label):
	label.add_theme_font_size_override("font_size", font_size)

func flip_to(next_value: int):
	if value == null:
		return

	label_next.text = str(next_value)
	label_next.visible = true

	label_next.position = Vector2(0, -height)
	
	var tween = create_tween()
	tween.parallel().tween_property(label_current, "position:y", label_current.position.y + height, speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(label_current, "modulate:a", 0.0, speed)
	tween.parallel().tween_property(label_next, "position:y", label_next.position.y + height, speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_callback(func ():
		value = next_value
		label_current.text = str(value)
		label_current.position = Vector2(0, 0)
		label_current.modulate.a = 1.0
		label_next.visible = false
	)
	
	return tween
