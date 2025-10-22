class_name OnAttackedTrigger
extends TriggerStrategy

func matches(context: EffectContext, source: BaseCard) -> bool:
	return context.event_type == "on_attacked" and context.payload.get("defender") == source
