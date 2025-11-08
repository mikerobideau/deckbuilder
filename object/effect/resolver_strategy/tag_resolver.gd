class_name TagResolver
extends ResolverStrategy

@export var amount: int
@export var tag: Tag.TagType

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData) -> void:
	for target in targets:
		await target.add_or_update_tag(tag, amount)
	finished.emit()
