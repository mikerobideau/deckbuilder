class_name Bounce extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_configure()
	await Animate.delay()
	animate_bounce()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _configure():
	pivot_offset = Vector2(size.x / 2, size.y / 2);

func animate_bounce():
	print_debug('bounce')
	var scale_tween = create_tween()
	scale_tween.set_trans(scale_tween.TRANS_BOUNCE)
	
	#Increase scale
	scale_tween.tween_property(self, 'scale', Vector2(1.25, 1.25), 0.3)
	scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.3)
	await scale_tween.finished
	
	#Shrink, squish, restore scale
	#scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.25), 0.2)
	#scale_tween.tween_property(self, 'scale', Vector2(1.0, 1.0), 0.1)
	#var bulge_tween = create_tween()
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.6, 0.2)
	#bulge_tween.tween_property(material, 'shader_parameter/bulge', 0.0, 0.1)
	await scale_tween.finished
