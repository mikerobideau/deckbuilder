class_name UnitCard
extends BaseCard

signal unit_card_targeted(card: UnitCard)
signal unit_card_health_depleted(card: UnitCard)
signal animation_complete()

@export var health: int
@onready var orb = $ParticleOrb
@onready var orb_pulse = $ParticleOrb/Orb/Pulse
@onready var heart = $Heart

var is_selected: bool = false
var rng: RandomNumberGenerator
		
func _ready():
	orb_pulse.material = orb_pulse.material.duplicate()
	orb.visible = false
	pivot_offset = size / 2
	_setup()
	mouse_filter = Control.MOUSE_FILTER_PASS
	
func setup(rng: RandomNumberGenerator):
	self.rng = rng
		
# ---- Effects ----
	
func _set_health(health) -> Signal:
	self.health = health
	return heart.set_health(health)
		
func take_damage(damage: int):
	#take damage to armor first
	var armor = tags.get_armor()
	var remaining_damage = damage
	if armor > 0:
		remaining_damage = max(damage - armor, 0)
		tags.take_armor_damage(damage)
	
	#then take damage to base health
	var new_health = max(health - remaining_damage, 0)

	if new_health == 0:
		unit_card_health_depleted.emit(self)

	_set_health(new_health)
	await Animate.chain([
		Animate.flash(self, Color.LIGHT_CORAL),
		Animate.shake(self),
		play_floating_text('-' + str(damage)),
	])
	
func heal(amount: int):
	if tags.has_antiheal():
		return
	var new_health = health + amount
	if new_health > data.max_health:
		new_health = data.max_health
	_set_health(new_health)
	
	await Animate.chain([
		Animate.flash(self, Color.YELLOW),
		Animate.shake(self),
		play_floating_text('+' + str(amount)),
	])

func _on_data_set():
	health = data.max_health
	
func _on_card_event(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		if is_location_board():
			unit_card_targeted.emit(self)
	
func effect_active():
	return !is_disabled

# ---- Visuals ----

func activate_orb():
	orb.visible = true
	await orb.on_for(Color.DEEP_PINK, Color.HOT_PINK, 1)
	orb.visible = false

func play_floating_text(text: String):
	floating_text.set_text(text)
	return floating_text.play()

func animate_place(position: Vector2):
	var duration = Const.ANIMATION_STEP / 2
	tilt(0, duration)
	await Animate.move(self, position)
	
# ---- Debug ----
func _notification(what):
	if what == 50: # NOTIFICATION_PARENTED
		print("\n===== DEBUG: PARENTED =====")
		print("Unit:", name)
		print("New parent:", get_parent())
		print("Stack:\n", get_stack())
		print("============================\n")

	if what == 51: # NOTIFICATION_UNPARENTED
		print("\n===== DEBUG: UNPARENTED =====")
		print("Unit:", name)
		print("Old parent changed")
		print("Stack:\n", get_stack())
		print("============================\n")
