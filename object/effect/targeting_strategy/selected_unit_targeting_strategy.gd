class_name SelectedUnitTargetingStrategy
extends TargetingStrategy

func select_targets(context: EffectContext, source: BaseCard) -> Array[UnitCard]:
	if context.selected_unit != null:
		return [context.selected_unit]
	return []
