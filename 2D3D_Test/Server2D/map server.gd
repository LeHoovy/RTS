extends TileMap
class_name MapServer
#used_tiles(): returns an array containing the position of every tile on the map.

#region Setup
signal finished_loading
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	(get_parent() as Node2D).visible = false
	
	var prepare_size: Vector2i = get_used_rect().size
	var prepare_pos: Vector2i = get_used_rect().position
	
	for x: int in range(prepare_size.x):
		for y: int in range(prepare_size.y):
			if get_cell_atlas_coords(0, Vector2i(x + prepare_pos.x, y + prepare_pos.y)) == Vector2i(-1, -1):
				set_cell(0, Vector2i(x + prepare_pos.x, y + prepare_pos.y), 0, Vector2i(0, 0))
	
	finished_loading.emit()
	
	generate_navigation_map()



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



func used_area() -> Vector4i:
	return Vector4i(get_used_rect().size.x, get_used_rect().size.y, get_used_rect().position.x, get_used_rect().position.y)



func get_cell_height(tile: Vector2i) -> Vector3i:
	var height: int = get_cell_atlas_coords(0, tile).x
	var type: int = get_cell_atlas_coords(0, tile).y
	
	if type == 1:
		#print(get_surrounding_cells(tile))
		for neighbor in get_surrounding_cells(tile):
			if get_cell_atlas_coords(0, neighbor).y == 1 and get_cell_atlas_coords(0, neighbor).x > height:
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
	
	return Vector2i(up_down_ramp, direction)
#endregion


#make a "get next point" function eventually
var triangle_count: int = 0
func generate_navigation_map() -> void:
	var not_yet_triangulated_tiles: Array[Vector2i] = []
	#var vertices: Dictionary
	var starting_point: Vector2i = used_tiles()[0] * 100
	starting_point.x += 50
	starting_point.y += 50
	#print(starting_point)
	
	var direction: Vector2i = Vector2i(1, 0)
	
	var tri: Tri = Tri.new()
	add_child(tri)
	tri.reposition_vertex(0, starting_point)
	
	var next_point: Vector2i = starting_point + (100 * direction)
	print(next_point)
	while true:
		if !compare_tile_height(local_to_map(next_point), local_to_map(next_point + (100 * direction))):
			break
		next_point += 100 * direction
	tri.reposition_vertex(1, next_point)
	
	if get_cell_atlas_coords(0, local_to_map(next_point + (100 * direction))) != Vector2i(-1, -1):
		not_yet_triangulated_tiles.append(local_to_map(next_point + (100 * direction)))
	direction = change_dir(direction)
	if !compare_tile_height(local_to_map(next_point), local_to_map(next_point + (100 * direction))):
		direction *= -1
		if get_cell_atlas_coords(0, local_to_map(next_point + (100 * direction))) != Vector2i(-1, -1):
			not_yet_triangulated_tiles.append(local_to_map(next_point + (100 * direction)))
	
	while true:
		if !compare_tile_height(local_to_map(next_point), local_to_map(next_point + (100 * direction))):
			break
		next_point += 100 * direction
	tri.reposition_vertex(2, next_point)




func change_dir(direction: Vector2i, clockwise: bool = true) -> Vector2i:
	var output_dir: Vector2i = Vector2i(0, 0)
	if clockwise:
		output_dir.x = direction.y
		output_dir.y = 0 - direction.x
	else:
		output_dir.x = 0 - direction.y
		output_dir.y = direction.x
	return output_dir



func compare_tile_height(tile_a: Vector2i, tile_b: Vector2i) -> bool:
	var height_a: int = get_cell_atlas_coords(0, tile_a).x
	var height_b: int = get_cell_atlas_coords(0, tile_b).x
	if height_a == height_b:
		return true
	return false
#part of setup but unfinished so not in the region yet
#func generate_triangles(affected_triangles: Array[Polygon2D]) -> void:
	#pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


