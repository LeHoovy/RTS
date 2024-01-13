extends GridMap
class_name Map


@export var open_ceilings: Array[int] = [-1]
@export var pathable_tiles: Array[int] = [0]


var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	bake_navmesh([])
	
	get_edges()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


#checks the cell if it can be pathed.
func check_cell_pathable(cell: Vector3i) -> bool:
	if open_ceilings.has(get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z))):
		return false
	if pathable_tiles.has(get_cell_item(cell)):
		return false
	return true


var triangle_preload: PackedScene = preload("res://debug/Tri.tscn")
func get_edges() -> void:
	for cell in get_used_cells():
		#print(cell)
		if check_cell_pathable(cell):
			continue
		
		var edge_tile: bool = false
		for neighbor in get_cell_neighbors(cell):
			if !(get_cell_item(neighbor) + 1):
				edge_tile = true
				break
		if !edge_tile:
			continue
		
		var triangle: Triangle = triangle_preload.instantiate()
		triangle.points.append(Vector3(cell.x, cell.y + cell_size.y + 1.2, cell.z) *2)
		triangle.points.append(Vector3(cell.x + 1, cell.y + cell_size.y + 1.2, cell.z) *2)
		triangle.points.append(Vector3(cell.x + 1, cell.y + 1.2, cell.z + 1) *2)
		add_child(triangle)
		#triangle.position = Vector3(cell.x + 0.5, cell.y + 1.15, cell.z)
		
		#print(cell, " is plausible for pathfinding.")


func bake() -> void:
	thread.start(bake_navmesh)


func bake_navmesh(affected: Array[Node]) -> void:
	for cell in get_used_cells():
		pass
	#print(get_cell_neighbors(Vector3i(0, 1, 0)))
	#print(get_cell_neighbors(Vector3i(0, 0, 0)).size())
	#print()
	#print(get_vertical_neighbors(Vector3i(0, 0, 0,)))
	#print(get_vertical_neighbors(Vector3i(0,0,0)).size())


func get_vertical_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i]
	neighbors.append_array(get_cell_neighbors(cell))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y - 1, cell.z)))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y + 1, cell.z)))
	return neighbors

#region get neighbors of cell 
func get_cell_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i] = [
		Vector3i(cell.x + 1, cell.y, cell.z),
		Vector3i(cell.x + 1, cell.y, cell.z - 1),
		Vector3i(cell.x, cell.y, cell.z - 1),
		Vector3i(cell.x - 1, cell.y, cell.z - 1),
		Vector3i(cell.x - 1, cell.y, cell.z),
		Vector3i(cell.x - 1, cell.y, cell.z + 1),
		Vector3i(cell.x, cell.y, cell.z + 1),
		Vector3i(cell.x + 1, cell.y, cell.z + 1)
	]
	return neighbors
