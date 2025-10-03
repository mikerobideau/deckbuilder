class_name AllPlantsTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: UnitCard) -> Array[UnitCard]:
	return context.plants
