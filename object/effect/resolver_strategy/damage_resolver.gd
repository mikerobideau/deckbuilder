class_name DamageResolver
extends ResolverStrategy

@export var amount := 2
@export var splash: bool
@export var splash_damage: int

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData) -> Event:
	var total_damage = 0
	for target in targets:
		if animation:
			animation.play(source)
		var boosted_amount
		if source is UnitCard:
			boosted_amount = amount + source.tags.get_damage_boost()
		else:
			boosted_amount = amount
		await target.take_damage(boosted_amount)
		total_damage += boosted_amount
		
		if splash:
			for splash_target in context.board.get_splash_targets(target):
				await splash_target.take_damage(splash_damage)
				total_damage += splash_damage
	
	var event = Event.new()
	event.effect_type = Effect.EffectType.DAMAGE
	event.amount = total_damage
	return event
