extends GridMap
class_name Map

#region Inspector variables
@export var open_ceilings : Array[int] = [-1]
@export var pathable_tiles : Array[int] = [0]
#endregion

var thread : Thread

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	bake_navmesh(get_used_cells())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


#region Basically, "hey is there anything above me" and "do I have enough space to be walked on"
func check_cell_pathable(cell: Vector3i) -> bool:
	if open_ceilings.has(get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z))):
		return false
	if pathable_tiles.has(get_cell_item(cell)):
		return false
	return true
#endregion


#region Build trongle
var triangle_preload : PackedScene = preload("res://debug/Tri.tscn")
func get_edges() -> void:
	for cell in get_used_cells():
		#print(cell)
		if check_cell_pathable(cell):
			continue
		
		var edge_tile : bool = false
		for neighbor in get_cell_neighbors(cell):
			if !(get_cell_item(neighbor) + 1):
				edge_tile = true
				break
		if !edge_tile:
			continue
		
#region Generate the triangle
		var triangle : Triangle_Mesh = triangle_preload.instantiate()
		add_child(triangle)
		triangle.position = Vector3(cell.x, cell.y + 1.2, cell.z)
		triangle.vertices.append(Vector3(1, 0, 0) * 2)
		triangle.vertices.append(Vector3(1, 0, 1) * 2)
		triangle.vertices.append(Vector3(0, 0, 0) * 2)
		triangle.gen_main()
		#triangle.gen_outline()
		triangle.gen_mesh()
		#triangle.set_surface(1, Color(0, 0.1, 0.5, 0.6))
		#triangle.outline = triangle.color
		#triangle.outline.cull_mode = 1
		#triangle.set_surface_override_material(1, triangle.outline)
#endregion
#endregion


func bake() -> void:
	thread.start(bake_navmesh.bind())


func bake_navmesh(affected : Array[Vector3i]) -> void:
	get_edges()
	#print(get_cell_neighbors(Vector3i(0, 1, 0)))
	#print(get_cell_neighbors(Vector3i(0, 0, 0)).size())
	#print()
	#print(get_vertical_neighbors(Vector3i(0, 0, 0,)))
	#print(get_vertical_neighbors(Vector3i(0,0,0)).size())

#region same thing as below but get tiles above and below too
func get_vertical_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors : Array[Vector3i]
	neighbors.append_array(get_cell_neighbors(cell))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y - 1, cell.z)))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y + 1, cell.z)))
	return neighbors
#endregion
#region get each cell surrounding my cell and add it to an array
func get_cell_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors : Array[Vector3i] = [
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
#endregion
