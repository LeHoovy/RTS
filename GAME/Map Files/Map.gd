extends GridMap
class_name Map

var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	bake_navmesh([])
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_edges() -> void:
	pass


func bake():
	thread.start(bake_navmesh)


func bake_navmesh(affected: Array[Node]) -> void:
	for cell in get_used_cells():
		pass
	print(get_cell_neighbors(Vector3i(0, 1, 0)))
	print(get_cell_neighbors(Vector3i(0, 0, 0)).size())
	print()
	print(get_vertical_neighbors(Vector3i(0, 0, 0,)))
	print(get_vertical_neighbors(Vector3i(0,0,0)).size())
	


func get_vertical_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i]
	neighbors.append_array(get_cell_neighbors(cell))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y - 1, cell.z)))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y + 1, cell.z)))
	return neighbors


func get_cell_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			if Vector2i(x, y) != Vector2i(0, 0):
				neighbors.append(Vector3i(cell.x + x, cell.y, cell.y + y))
	return neighbors
