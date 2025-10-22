class_name ItemData
extends BaseCardData

enum EnergyType { YELLOW, GREEN, PURPLE }

@export var energy: EnergyType
@export var effect: ItemEffect
@export var has_targets: bool = true
