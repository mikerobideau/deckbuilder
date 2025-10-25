class_name Cell
extends Control

signal cell_clicked(cell: Cell)

@onready var background = $Background

const CellShader = preload("res://shader/cell_shader.gdshader")
const HighlightShader = preload("res://shader/highlight_shader.gdshader")

const SIZE = Const.CARD_SIZE

var row: int
var column: int
var unit: UnitCard = null
var _is_selected := false
var _is_zone_highlight := false
var _cell_mat: ShaderMaterial
var _highlight_mat: ShaderMaterial

func _ready():
	_cell_mat = ShaderMaterial.new()
	_cell_mat.shader = CellShader
	_cell_mat.resource_local_to_scene = true
	_highlight_mat = ShaderMaterial.new()
	_highlight_mat.shader = HighlightShader
	_highlight_mat.resource_local_to_scene = true
	background.material = _cell_mat

func place_unit(unit_card: UnitCard) -> void:
	if unit:
		unit.queue_free()
	unit = unit_card

	if unit_card.get_parent():
		unit_card.get_parent().remove_child(unit_card)

	add_child(unit_card)
	unit_card.global_position = global_position

func remove_unit() -> void:
	if unit:
		unit.queue_free()
		unit = null

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
		background.material.set_shader_parameter("border_color", Const.HIGHLIGHT_COLOR)
	elif _is_zone_highlight:
		background.material.set_shader_parameter("border_color", Const.PREVIEW_COLOR)
	else:
		background.material.set_shader_parameter("border_color", Const.BORDER_GREY)
