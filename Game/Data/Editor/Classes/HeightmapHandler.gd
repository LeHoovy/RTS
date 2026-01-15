class_name HeightmapHandler extends Resource
 

#var h_map: Image # Image class for handling the heightmap
static var cur_hmap: PackedByteArray
var editor_maps_path := "res://Game/Data/Editor/Maps/"
var size: Vector2i # Map size
#var map_path: String # Used for saving and loading heightmap data


func _init(map_size: Vector2i) -> void:
	#_image = Image.new()
	size = map_size


static func gen_new_heightmap(initial_depth: int) -> PackedByteArray:
	
	
	return []


func load_new_heightmap(map_name: String) -> void:
	pass


static func get_tile_pos(x: int, y: int) -> Vector2i:
	
	
	return Vector2i()
