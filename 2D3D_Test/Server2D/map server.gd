extends TileMap
class_name MapServer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func used_tiles() -> Array[Vector2i]:
	var tiles_size: Vector2i = get_used_rect().size
	var tiles_start: Vector2i = get_used_rect().position
	var used_tiles_arr: Array[Vector2i] = []
	#print(tiles_size, tiles_start, tiles_size + tiles_start)
	
	for x: int in range(tiles_size.x):
		for y: int in range(tiles_size.y):
			#print('(', x, ', ', y,')')
			if get_cell_atlas_coords(0, Vector2i(x + tiles_start.x, y + tiles_start.y)) != Vector2i(-1, -1):
				used_tiles_arr.append(Vector2i(x + tiles_start.x, y + tiles_start.y))
	
	return used_tiles_arr



func get_cell_height(tile: Vector2i) -> Vector3i:
	var height: int = get_cell_atlas_coords(0, tile).x
	var type: int = get_cell_atlas_coords(0, tile).y
	
	if type == 1:
		#print(get_surrounding_cells(tile))
		for neighbor in get_surrounding_cells(tile):
			if get_cell_atlas_coords(0, neighbor).x > height:
				height += 1
	
	return Vector3i(tile.x, height, tile.y)


const vert_dir: Array[int] = [
	1, 3
]
func get_cell_type_dir(tile: Vector2i) -> Vector2i:
	var self_type: Vector2i = get_cell_atlas_coords(0, tile)
	var ramp_neighbor: Vector2i
	var direction: int = 0
	
	if self_type.y == 0:
		return Vector2i(0, 0)
	
	for neighbor in get_surrounding_cells(tile):
		if get_cell_atlas_coords(0, neighbor).y == 1 and get_cell_atlas_coords(0, neighbor).x != self_type.x:
			ramp_neighbor = neighbor
			break
		direction += 1
	
	var up_down_ramp: int = 1
	if get_cell_atlas_coords(0, ramp_neighbor).x > self_type.x:
		up_down_ramp += 1
	if up_down_ramp == 2 and vert_dir.has(direction):
		direction = 4 - direction
	elif up_down_ramp == 2:
		direction = 2 - direction
	
	return Vector2i(up_down_ramp, direction)
