class_name AllPlantsTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	return context.plants
