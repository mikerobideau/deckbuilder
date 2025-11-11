class_name ItemData
extends BaseCardData

enum EnergyType { YELLOW, GREEN, PURPLE }
enum TargetType { HERO, ENEMY, NONE }

@export var energy: EnergyType
@export var target_type: TargetType
@export var effect: ItemEffect
@export var animation: AnimationData
