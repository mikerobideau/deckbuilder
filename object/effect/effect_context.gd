class_name EffectContext
extends Resource

var source_unit: UnitCard
var target_units: Array[UnitCard] = []
var event_type: String = ""   # e.g. "on_attacked", "after_damage_dealt", "on_energy_played"
var payload := {}             # arbitrary: damage, heal amounts, stun_count, item_color, etc.
var source: BaseCard
var board: ControlBoard
var hand: Hand
var card_factory: CardFactory
var heroes: Array[UnitCard] = []
var enemies: Array[UnitCard] = []
var selected_unit: UnitCard
var currency: Currency
