class_name CardFactory
extends RefCounted

var BaseCardScene = preload("res://object/card/base_card.tscn")

func create(data: BaseCardData) -> BaseCard:
	var scene = BaseCardScene.instantiate()
	
	if data is HeroData:
		scene.set_script(preload("res://object/hero/hero.gd"))
	elif data is EventData:
		scene.set_script(preload("res://object/event/event.gd"))
	else:
		scene.set_script(preload("res://object/card/card.gd"))
	
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
