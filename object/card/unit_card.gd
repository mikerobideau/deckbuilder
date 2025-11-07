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
	
func _set_health(health):
	self.health = health
	return heart.set_health(health)
		
func trigger_ability(energy: ItemData.EnergyType, context: EffectContext, source: BaseCard):
	var ability = _find_ability(energy)
	if ability:
		ability.apply(context, self)
		
func take_damage(amount: int):
	var new_health = max(health - amount, 0)

	if new_health == 0:
		unit_card_health_depleted.emit(self)

	await Animate.chain([
		Animate.flash(self, Color.LIGHT_CORAL),
		Animate.shake(self)
	])
	#await [
	#	#_set_health(new_health),
		#t1.finished,
		#t2.finished
		#await play_floating_text('-' + str(amount))
	#]
	#await t2.finished

func heal(amount: int):
	if tags.has_antiheal():
		return
	var new_health = health + amount
	if new_health > data.max_health:
		new_health = data.max_health
	_set_health(new_health)

func _on_data_set():
	health = data.max_health
	
func _on_card_event(event: InputEvent) -> void:
	if InputUtil.is_left_click(event):
		if is_location_board():
			unit_card_targeted.emit(self)
	
func effect_active():
	return !is_disabled
	
func _find_ability(energy: ItemData.EnergyType):
	for ability in data.abilities:
		if ability.energy == energy:
			return ability
	return null

# ---- Visuals ----

func activate_orb():
	orb.visible = true
	await orb.on_for(Color.DEEP_PINK, Color.HOT_PINK, 1)
	orb.visible = false

func play_floating_text(text: String):
	floating_text.set_text(text)
	floating_text.play()

func animate_attack(target_position: Vector2):
	tilt(10.0)
	await Animate.move(self, target_position)

func animate_retreat(retreat_position: Vector2):
	tilt(0)
	await Animate.move(self, retreat_position)

func animate_place(position: Vector2):
	var duration = Const.ANIMATION_STEP / 2
	tilt(0, duration)
	await Animate.move(self, position)
