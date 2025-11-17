class_name Tag
extends Control

signal expired(tag: Tag)

enum TagType { BOOSTED, ANTIHEAL, DISABLED, ARMOR }

@onready var bg: ColorRect = ColorRect.new()
@onready var label: Label = Label.new()

@export var amount: int:
	set(value):
		set_amount(value)
	get:
		return _amount

@export var tick_amount: int:
	set(value):
		set_tick_amount(value)
	get:
		return _tick_amount
@export var type: TagType

var is_tick: bool = false
var is_tick_started: bool = false
var is_tick_completed: bool = false
var _amount: int = -1
var _tick_amount : int = 0

func _ready() -> void:
	bg.color = _get_tag_color()
	add_child(bg)

	label.text = str(amount)
	label.modulate = Color.BLACK
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(label)
	_update_label()

func set_amount(value: int) -> void:
	#print_debug('setting amount ' + str(value))
	_amount = value
	if label:
		_update_label()
	else:
		push_warning('tried to set amount, but there is no label')

func set_tick_amount(value: int) -> void:
	_tick_amount = value
	if label:
		_update_label()

func add_amount(add: int):
	set_amount(_amount + add)
	
func add_tick_amount(add: int):
	set_tick_amount(tick_amount + add)

func get_amount() -> int:
	return _amount
	
func _update_label():
	if is_tick:
		label.text = str(_tick_amount)
	else:
		label.text = str(_amount)
	var padding = Vector2(12, 6)
	var min_size = label.get_minimum_size() + padding
	bg.size = min_size
	label.size = min_size

func _get_tag_color():
	match type:
		TagType.BOOSTED:
			return Const.TAG_COLOR_BOOSTED
		TagType.ANTIHEAL:
			return Const.TAG_COLOR_ANTIHEAL
		TagType.DISABLED:
			return Const.TAG_COLOR_DISABLED
		TagType.ARMOR:
			return Const.TAG_COLOR_ARMOR
			
func tick():
	if is_tick_completed:
		return
	if !is_tick_started:
		is_tick_started = true
		return
	if _tick_amount <= 1:
		set_tick_amount(0)
		expired.emit(self)
		return
	else:
		var new_tick_amount = _tick_amount - 1
		set_tick_amount(_tick_amount - 1)
