class_name AllEventsTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: UnitCard) -> Array[UnitCard]:
	return context.events
