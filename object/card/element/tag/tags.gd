class_name Tags
extends HBoxContainer

signal tag_expired(tag: Tag)

var TagScene = preload("res://object/card/element/tag/tag.tscn")
var Tag = preload("res://object/card/element/tag/tag.gd")
var TagType = Tag.TagType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_or_update_cursed_tag(amount: int):
	_add_or_update_tag(TagType.CURSED, amount)
	
func add_or_update_boosted_tag(amount: int):
	_add_or_update_tag(TagType.BOOSTED, amount)
	
func add_or_update_disabled_tag(amount: int):
	_add_or_update_tag(TagType.DISABLED, amount, true)
	
func _add_or_update_tag(type: Tag.TagType, amount: int, is_tick: bool = false):
	var existing_tag = _get_tag_by_type(type)
	if existing_tag:
		_update_tag(existing_tag, amount, is_tick)
	else:
		_add_tag(type, amount, is_tick)
			
func _get_tag_by_type(type: Tag.TagType) -> Tag:
	for tag in get_children():
		if tag.type == type:
			return tag
	return null

func _update_tag(tag: Tag, amount: int, is_tick: bool):
	#print_debug('updating tag')
	if is_tick:
		tag.add_tick_amount(amount)
	else:
		tag.add_amount(amount)

func _add_tag(type: Tag.TagType, amount: int, is_tick: bool = false):
	#print_debug('adding tag')			
	var tag = TagScene.instantiate()
	tag.type = type
	tag.is_tick = is_tick
	if is_tick:
		tag.set_tick_amount(amount)
	else:
		tag.set_amount(amount)
	tag.expired.connect(_on_tag_expired)
	add_child(tag)
	
func _on_tag_expired(tag: Tag):
	tag_expired.emit(tag)
	tag.queue_free()
