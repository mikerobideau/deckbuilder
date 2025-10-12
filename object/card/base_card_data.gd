class_name BaseCardData
extends Resource

enum CardType { BASE, CARD, UNIT, PLANT, EVENT }

@export var name: String
@export var rarity: BaseCard.Rarity
@export var effect: Effect

var type := CardType.BASE
