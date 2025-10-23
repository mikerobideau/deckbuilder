class_name Enemy
extends UnitCard

func _configure_card():
	set_location_to_board()

func apply(context: EffectContext):
	print_debug('applying enemy ability')
	if effect_active():
		pulse()
		var choices = data.effects
		var active_effect = choices[rng.randi_range(0, choices.size() - 1)]
		active_effect.apply(context, self)
