class_name Cell
extends Control

signal cell_clicked(cell: Cell)

@onready var background = $Background
@onready var background_base = $BackgroundBase

const HighlightShader = preload("res://shader/highlight_shader.gdshader")

var row: int
var column: int
var unit: UnitCard = null
var _is_selected := false
var _is_zone_highlight := false
var _cell_mat: ShaderMaterial
var _highlight_mat: ShaderMaterial
var default_color = Const.BORDER_GREY

func _ready():
	_cell_mat = ShaderMaterial.new()
	_cell_mat.resource_local_to_scene = true
	_highlight_mat = ShaderMaterial.new()
	_highlight_mat.shader = HighlightShader
	_highlight_mat.resource_local_to_scene = true
	background.modulate.a = 0.0
	background.material.set_shader_parameter("border_color", default_color)
	size = Const.CELL_SIZE

func place_unit(unit_card: UnitCard) -> void:
	if unit:
		remove_unit_reference()
	unit = unit_card

	if unit_card.get_parent():
		unit_card.get_parent().remove_child(unit_card)
	add_child(unit_card)

func remove_unit_reference() -> UnitCard:
	if unit:
		unit = null
	return unit

func is_empty() -> bool:
	return unit == null

func is_occupied_by_hero() -> bool:
	return unit is Hero

func is_occupied_by_enemy() -> bool:
	return unit is Enemy

func _on_gui_input(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		emit_signal("cell_clicked", self)

# ---- Visuals ----

func set_zone_highlight(on: bool) -> void:
	_is_zone_highlight = on
	_update_visual()

func set_selected(on: bool) -> void:
	_is_selected = on
	_update_visual()

func _update_visual() -> void:
	if _is_selected:
		background.modulate.a = 1.0
		background.material.set_shader_parameter("border_color", Const.HIGHLIGHT_COLOR)
	elif _is_zone_highlight:
		background.modulate.a = 1.0
		background.material.set_shader_parameter("border_color", Const.PREVIEW_COLOR)
	else:
		background.modulate.a = 0.0
