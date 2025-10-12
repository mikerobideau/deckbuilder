class_name EnemySlot
extends Panel

var enemy: Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	custom_minimum_size = Vector2(175, 250)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color.GRAY
	stylebox.corner_radius_top_left = 16
	stylebox.corner_radius_top_right = 16
	stylebox.corner_radius_bottom_left = 16
	stylebox.corner_radius_bottom_right = 16
	add_theme_stylebox_override("panel", stylebox)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_empty() -> bool:
	return enemy == null
	
func add_enemy(enemy: Enemy) -> void:
	if not is_empty():
		push_warning('Enemy slot - Tried to add enemy, but slot is already occupied')
		return
	self.enemy = enemy
	enemy.position = Vector2.ZERO
	add_child(enemy)

func clear() -> void:
	enemy = null
