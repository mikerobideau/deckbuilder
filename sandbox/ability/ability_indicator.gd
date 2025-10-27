class_name AbilityRect
extends Control

@onready var label = $LabelContainer/Label
@onready var glow = $Glow

@export var energy: ItemData.EnergyType
@export var duration = Const.ANIMATION_STEP
func _ready() -> void:
	init_color()
	
func init_color():
	match energy:
		ItemData.EnergyType.YELLOW:
			glow.material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_YELLOW)
		ItemData.EnergyType.GREEN:
			glow.material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_GREEN)
		ItemData.EnergyType.PURPLE:
			glow.material.set_shader_parameter('glow_color', Const.COLOR_ENERGY_PURPLE)
		#_:
		#	push_warning('Ability has unknown energy type ' + str(energy))
		#	return Color.WHITE

func _process(delta: float) -> void:
	pass

func on():
	glow.material.set_shader_parameter('pulse_speed', 5)
	glow.material.set_shader_parameter('pulse_enabled', true)

func on_for(time: int):
	on()
	await Animate.delay(time)
	off()

func off():
	glow.material.set_shader_parameter('pulse_speed', 0)
	glow.material.set_shader_parameter('pulse_enabled', false)
