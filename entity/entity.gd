class_name Entity extends RefCounted

var items = []

func find_by_name(name: String) -> Variant:
	for item in items:
		if item.name == name:
			return item
	push_error('find_by_name could not find %s' % name)
	return null
	
func find_by_title(title: String) -> Variant:
	for item in items:
		if item.title == title:
			return item
	push_error('find_by_title could not find %s' % title)
	return null
	
func all() -> Array:
	return items
