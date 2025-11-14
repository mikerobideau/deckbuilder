class_name TagResolver
extends ResolverStrategy

@export var amount: int
@export var tag: Tag.TagType

func apply(context: EffectContext, source: BaseCard, targets: Array[UnitCard], animation: AnimationData) -> void:
	print_debug('Calling tag resolver')
	for target in targets:
		if animation:
			animation.play(source)
		print_debug('adding/updating tag')
		await target.add_or_update_tag(tag, amount)
	finished.emit()
