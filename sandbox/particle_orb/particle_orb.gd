class_name ParticleOrb 
extends Control

@onready var orb = $Orb
@onready var pulse = $Orb/Pulse
@onready var particles = $Orb/Particles

@export var intensity_on = 1.2
@export var intensity_off = 0
@export var spread_on = 1.8
@export var spread_off = 2
@export var pulse_speed = 3
@export var default_color = Color.WHITE

func _ready() -> void:
	off()

func _process(delta: float) -> void:
	pass

func on(background_color: Color, particle_color: Color):
	orb.material.set_shader_parameter('color', background_color)
	
	pulse.material.set_shader_parameter('glow_color', particle_color)
	pulse.material.set_shader_parameter('intensity', intensity_on)
	pulse.material.set_shader_parameter('spread', spread_on)
	pulse.material.set_shader_parameter('pulse_speed', pulse_speed)
	pulse.material.set_shader_parameter('pulse_enabled', true)
	
	particles.color = particle_color
	particles.visible = true

func off():
	orb.material.set_shader_parameter('color', default_color)
	
	pulse.material.set_shader_parameter('intensity', intensity_off)
	pulse.material.set_shader_parameter('spread', spread_off)
	pulse.material.set_shader_parameter('pulse_speed', 0)
	pulse.material.set_shader_parameter('pulse_enabled', false)
	
	particles.visible = false

func on_for(background_color: Color, particle_color: Color, time: int):
	on(background_color, particle_color)
	await Animate.delay(time)
	off()
