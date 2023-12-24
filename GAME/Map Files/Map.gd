extends GridMap
class_name Map


@export var open_cielings: Array[int] = [-1]
@export var pathable_tiles: Array[int] = [0]


var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	bake_navmesh([])
	
	get_edges()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var triangle_preload: PackedScene = preload("res://debug/Tri.tscn")
func get_edges() -> void:
	for cell in get_used_cells():
		#print(cell)
		if open_cielings.has(get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z))) and pathable_tiles.has(get_cell_item(cell)):
			var triangle: Node = triangle_preload.instantiate()
			add_child(triangle)
			triangle.position = Vector3(cell.x, cell.y + 1.15, cell.z)
			
			print(cell, " is plausible for pathfinding.")
			


func bake():
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


func get_cell_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors: Array[Vector3i]
	for x in range(-1, 2):
		for y in range(-1, 2):
			if Vector2i(x, y) != Vector2i(0, 0):
				neighbors.append(Vector3i(cell.x + x, cell.y, cell.y + y))
	return neighbors
