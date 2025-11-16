class_name ItemData
extends BaseCardData

@export_group('Item Properties')

enum EnergyType { NONE, STRENGTH, VITALITY, FORTUNE, WISDOM, MAGIC, TECH }
enum TargetType { HERO, ENEMY, NONE }

@export var energy: EnergyType
@export var target_type: TargetType
@export var effect: ItemEffect
@export var animation: AnimationData
