class_name CardFactory
extends RefCounted

var BaseCardScene = preload("res://object/card/base_card.tscn")
var HeroScene = preload('res://object/card/hero/hero.tscn')
var ItemScene = preload('res://object/card/item/item.tscn')
var EnemyScene = preload('res://object/card/enemy/enemy.tscn')
var BoardObjectScene = preload('res://object/card/board_object/board_object.tscn')

func create(data: BaseCardData) -> BaseCard:
	var scene
	if data is HeroData:
		scene = HeroScene.instantiate()
		scene.set_script(preload("res://object/card/hero/hero.gd"))
	elif data is EnemyData:
		scene = EnemyScene.instantiate()
		scene.set_script(preload("res://object/card/enemy/enemy.gd"))
	elif data is BoardObjectData:
		scene = BoardObjectScene.instantiate()
		scene.set_script(preload("res://object/card/board_object/board_object.gd"))
	else:
		scene = ItemScene.instantiate()
		scene.set_script(preload("res://object/card/item/item.gd"))
	
	scene.data = data
	scene.id = _id(data)
	return scene as BaseCard

func _id(data: BaseCardData) -> StringName:
	return generate_uuid_v4()

func generate_uuid_v4():
	var uuid_chars = "0123456789abcdefghijklmnopqrstuvwxyz"
	var uuid_parts = []

	# Generate 32 random hex characters
	for i in range(32):
		uuid_parts.append(uuid_chars[randi() % uuid_chars.length()])

	# Apply UUIDv4 specific characters and hyphens
	uuid_parts[14] = "4" # Version 4
	uuid_parts[19] = uuid_chars[8 + (randi() % 4)] # Variant (8, 9, a, or b)

	# Insert hyphens
	uuid_parts.insert(8, "-")
	uuid_parts.insert(13, "-")
	uuid_parts.insert(18, "-")
	uuid_parts.insert(23, "-")

	return "".join(uuid_parts)
