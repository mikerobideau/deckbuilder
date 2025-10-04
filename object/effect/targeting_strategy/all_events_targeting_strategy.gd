class_name AllEventsTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return context.events
