class_name HeroSlot
extends Panel

signal hero_slot_selected(slot: HeroSlot)

@export var slot_index: int

var hero: Hero       = null
var is_selected: bool = false
var stylebox: StyleBox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(175, 250)
	stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Const.DEFAULT_BED_COLOR
	stylebox.corner_radius_top_left = 16
	stylebox.corner_radius_top_right = 16
	stylebox.corner_radius_bottom_left = 16
	stylebox.corner_radius_bottom_right = 16
	add_theme_stylebox_override("panel", stylebox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_empty() -> bool:
	return hero == null
	
func add_hero(hero: Hero) -> void:
	if not is_empty():
		push_warning('Garden Bed - Tried to add hero, but slot is already occupied')
		return
	self.hero = hero
	if hero.get_parent():
		hero.get_parent().remove_child(hero)
	hero.position = Vector2.ZERO
	add_child(hero)
	
func set_selected(selected: bool) -> void:
	is_selected = selected
	_update_visual()
	
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hero_slot_selected.emit(self)
		
func _update_visual() -> void:
	if is_selected:
		stylebox.bg_color = Const.HIGHLIGHT_COLOR
	else:
		stylebox.bg_color = Const.DEFAULT_BED_COLOR
		
func clear():
	hero = null
