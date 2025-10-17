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
	
func add_or_update_tag(type: Tag.TagType, amount: int):
	match type:
		Tag.TagType.BOOSTED:
			_add_or_update_tag(TagType.BOOSTED, amount)
		Tag.TagType.ANTIHEAL:
			_add_or_update_tag(TagType.ANTIHEAL, amount)
		Tag.TagType.DISABLED:
			_add_or_update_tag(TagType.DISABLED, amount, true)

func get_damage_boost() -> int:
	var tag = _get_tag_by_type(Tag.TagType.BOOSTED)
	if tag:
		return tag.get_amount()
	return 0
	
func has_antiheal() -> bool:
	if _has_tag(Tag.TagType.ANTIHEAL):
		return true
	return false
	
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

func _has_tag(type: Tag.TagType) -> bool:
	if _get_tag_by_type(type):
		return true
	return false

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
