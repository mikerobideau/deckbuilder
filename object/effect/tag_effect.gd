class_name TagEffect
extends Effect

@export var tag_type: Tag.TagType
@export var amount: int

func apply(context: EffectContext, source: BaseCard) -> void:
	for target in get_targets(context, source):
		target.add_or_update_tag(tag_type, amount)
