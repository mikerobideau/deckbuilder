class_name AddCardResolver
extends ResolverStrategy

@export var amount := 2
@export var card: BaseCardData

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData):
	if animation:
		animation.play(source)
	var card_scene = context.card_factory.create(card)
	await context.hand.add_card(card_scene)
