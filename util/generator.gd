class_name Generator extends RefCounted

var rng: RandomNumberGenerator

func _init(rng: RandomNumberGenerator):
	self.rng = rng

func get_weighted_item_pool(items: Array) -> Array:
	var pool: Array = []
	var total := 0.0
	for item in items:
		total += item.rarity.weight
		pool.append([item, total])
	return pool
	
func gen(items: Array) -> Variant:
	var pool = get_weighted_item_pool(items)
	var roll = rng.randf_range(0.0, pool.back()[1])
	for pair in pool:
		if roll <= pair[1]:
			return pair[0]
	return null
