class_name Generator extends RefCounted

var rng: RandomNumberGenerator

var rarity_weights: Dictionary = {
	BaseCard.Rarity.COMMON: 1,
	BaseCard.Rarity.UNCOMMON: 0.25,
	BaseCard.Rarity.RARE: 0.05,
	BaseCard.Rarity.LEGENDARY: 0.01
}

func _init(rng: RandomNumberGenerator):
	self.rng = rng

func get_weighted_item_pool(items: Array) -> Array:
	var pool: Array = []
	var total := 0.0
	for item in items:
		total += rarity_weights.get(item.rarity, 0.0)
		pool.append([item, total])
	return pool
	
func gen(items: Array) -> Variant:
	var pool = get_weighted_item_pool(items)
	var roll = rng.randf_range(0.0, pool.back()[1])
	for pair in pool:
		if roll <= pair[1]:
			return pair[0]
	return null
