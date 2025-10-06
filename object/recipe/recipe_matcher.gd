class_name RecipeMatcher
extends RefCounted

var recipes: Array[Recipe] = []
var recipe_path = "res://resource/recipe"

func _init():
	var dir := DirAccess.open(recipe_path)
	if dir == null:
		print_debug("Recipe directory not found: " + recipe_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tres"):
				var path = recipe_path + '/' + file_name
				var recipe = load(path)
				if recipe:
					print_debug('adding recipe')
					recipes.append(recipe)
				else:
					print_debug('unable to load recipe')
			file_name = dir.get_next()
		dir.list_dir_end()

func match(ingredients: Array[BaseCardData]) -> Recipe:
	print_debug('matching against ' + str(recipes.size()))
	for recipe in recipes:
		print_debug('checking ' + recipe.name)
		if _ingredients_match(recipe.ingredients, ingredients):
			return recipe
	return null
	
func _ingredients_match(a: Array[BaseCardData], b: Array[BaseCardData]):
	if a.size() != b.size():
		print_debug('different size')
		return false
		
	#Note: Order doesn't matter
	var copy_a = a.duplicate()
	var copy_b = b.duplicate()
	
	for ingredient in copy_a:
		if ingredient in copy_b:
			print_debug('found ingredient ' + ingredient.name)
			copy_b.erase(ingredient)
		else:
			print_debug('couldn\'t find ingredient ' + ingredient.name)
			return false
			
	return copy_b.is_empty()
