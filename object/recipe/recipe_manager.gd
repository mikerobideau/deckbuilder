class_name RecipeManager
extends MarginContainer

@onready var label = $Label

var recipes: Array[Recipe] = []
var recipe_path = "res://resource/recipe"

func _init():
	var dir := DirAccess.open(recipe_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var path = recipe_path + '/' + file_name
				var recipe = load(path)
				if recipe:
					recipes.append(recipe)
			file_name = dir.get_next()
		dir.list_dir_end()

func match(cards: Array[BaseCard]) -> Recipe:
	var ingredients: Array[BaseCardData] = []
	for card in cards:
		ingredients.append(card.data)
	for recipe in recipes:
		if _ingredients_match(recipe.ingredients, ingredients):
			return recipe
	return null
	
func _ingredients_match(a: Array[BaseCardData], b: Array[BaseCardData]):
	if a.size() != b.size():
		return false
		
	#Note: Order doesn't matter
	var copy_a = a.duplicate()
	var copy_b = b.duplicate()
	
	for ingredient in copy_a:
		if ingredient in copy_b:
			copy_b.erase(ingredient)
		else:
			return false
			
	return copy_b.is_empty()

func set_text(text: String) -> void:
	label.text = text

func get_text() -> String:
	return label.text

func clear() -> void:
	label.text = ''
