class_name EditorDataGDScript extends Resource


static var map_quick_access_details: Dictionary[String, Variant] = {}
static var current_map_path: String:
	set(new_path):
		current_map_path = new_path
		var map_details := FileAccess.open(new_path.path_join("map.JSON"), FileAccess.READ)
		map_quick_access_details = (
				JSON.parse_string(map_details.get_as_text()) # Broken?
		)
		map_details.close()
