class_name AbilityRect
extends Control

@export var energy: ItemData.EnergyType

func _ready() -> void:
	material.set_shader_parameter('intensity', 1.7)
	material.set_shader_parameter('spread', 1.1)
	off()
	init_color()
	
func init_color():
	match energy:
		ItemData.EnergyType.YELLOW:
			material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_YELLOW)
		ItemData.EnergyType.GREEN:
			material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_GREEN)
		ItemData.EnergyType.PURPLE:
			material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_PURPLE)

func _process(delta: float) -> void:
	pass

func on():
	material.set_shader_parameter('pulse_speed', 10)
	material.set_shader_parameter('pulse_enabled', true)

func on_for(time: int):
	on()
	await Animate.delay(time)
	off()

func off():
	material.set_shader_parameter('pulse_speed', 0)
	material.set_shader_parameter('pulse_enabled', false)
