class_name HeightmapHandler extends Image
 

#var _image: Image # Image class for handling the heightmap
var size: Vector2i # Map size
#var map_path: String # Used for saving and loading heightmap data


func _init(map_size: Vector2i) -> void:
	#_image = Image.new()
	size = map_size


func new_heightmap(initial_depth: int) -> void:
	var new_img: PackedByteArray = []
	new_img.resize(size.x * size.y)
	new_img.fill(initial_depth)
	
	data = create_from_data(size.x, size.y, false, FORMAT_R8, new_img).data
	save_png("res://Game/Data/Maps/test.png")
