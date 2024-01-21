extends GridMap
class_name Map

#region Inspector variables
@export var open_ceilings : Array[int] = [-1]
#endregion

var thread : Thread
var edges : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	bake_navmesh(get_used_cells())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


#region Basically, "hey is there anything above me" and "am I an edge"
func check_for_ceiling(cell: Vector3i) -> bool:
	if open_ceilings.has(get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z))):
		return false
	return true


func check_for_edge(cell : Vector3i) -> bool:
	var is_edge : bool = false
	for neighbor in get_cell_neighbors(cell):
		if !(get_cell_item(neighbor) + 1):
			is_edge = true
			break
	if !is_edge:
		for neighbor in get_cell_quad_neighbors(Vector3i(cell.x, cell.y+1, cell.z)):
			if get_cell_item(neighbor) != -1:
				is_edge = true
	return is_edge
#endregion

var triangle_preload : PackedScene = preload("res://debug/Tri.tscn")
func get_edges() -> Dictionary:
	var edge_dictionary : Dictionary
	var edge_count : int = 0
	for cell in get_used_cells():
		
		if check_for_ceiling(cell):
			continue
		if !check_for_edge(cell):
			continue
		
		edge_dictionary[cell] = edge_generation_handler(cell)
		edge_count += 1
		
		#region plans
		# generate 9 vertexes per cell, so each tile has 4 vertexes, or every 0.5 meters
		# remove vertexes until they line up with edges of the cell
		# move remaining vertexes to have about 0.25 meters of space between edges of the triangle and the cell
		# add them to list
		#endregion
		
		
	#print(edge_dictionary)
	return edge_dictionary


func edge_generation_handler(cell_pos : Vector3i) -> Array[Vector3]:
	var cell_edges : Array[bool]
	
	for for_neighbor in get_cell_quad_neighbors(cell_pos):
		cell_edges.append(get_neighbor_edge(for_neighbor))
	
	var is_covered : bool = check_for_ceiling(cell_pos)
	#edge_dictionary[str('edge', edge_count)] = cell_pos
	return generate_edges(bool(get_cell_item(Vector3i(cell_pos.x, cell_pos.y + 1, cell_pos.z)) + 1), cell_edges)


func get_neighbor_edge(cell : Vector3i) -> bool:
	if get_cell_item(cell) + 1:
		return false
	if get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z)) + 1:
		return false
	return true


func generate_edges(roof : bool, edges : Array[bool]) -> Array[Vector3]:
	var edge_array : Array[Vector3] = [
		Vector3(0, 0, 0), # top left
		Vector3(0.5, 0, 0), #mid up
		Vector3(1, 0, 0), #top right
		Vector3(0, 0, 0.5), # mid left
		Vector3(0.5, 0, 0.5), # middle
		Vector3(1, 0, 0.5), # mid right
		Vector3(0, 0, 1), #bottom left
		Vector3(0.5, 0, 1), # mid bottom
		Vector3(1, 0, 1) #bottom right
	]
	
	#region Edge-check
	if !edges[1] and !edges[0]:
		edge_array.remove_at(8)
	if !edges[1]:
		edge_array.remove_at(7)
	if !edges[1] and !edges[2]:
		edge_array.remove_at(6)
	if !edges[0]:
		edge_array.remove_at(5)
	if !edges[0] and !edges[1] and !edges[2] and !edges[3] or !roof:
		edge_array.remove_at(4)
	if !edges[2]:
		edge_array.remove_at(3)
	if !edges[0] and !edges[3]:
		edge_array.remove_at(2)
	if !edges[3]:
		edge_array.remove_at(1)
	if !edges[3] and !edges[2]:
		edge_array.remove_at(0)
	#endregion
	
	return edge_array


func bake() -> void:
	thread.start(bake_navmesh.bind())


func bake_navmesh(affected : Array[Vector3i]) -> void:
#region Generate the triangle
	var edge_dict : Dictionary = get_edges()
	for i : Vector3i in edge_dict.keys():
		var triangle : Triangle_Mesh = triangle_preload.instantiate()
		#print(i)
		for vector : Vector3 in edge_dict.get(i):
			triangle.vertices.append(vector + Vector3(i as Vector3))
			#print(vector)
		add_child(triangle)
		#triangle.vertices.append(Vector3(i.x, i.y + 1.01, i.z)) #Top-left corner
		#triangle.vertices.append(Vector3(i.x + 1, i.y + 1.01, i.z)) # Top-right corner
		#triangle.vertices.append(Vector3(i.x + 1, i.y + 1.01, i.z + 1)) # Bottom-right corner
		triangle.gen_main()
#endregion


#region get each cell surrounding my cell and add it to an array
func get_vertical_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors : Array[Vector3i]
	neighbors.append_array(get_cell_neighbors(cell))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y - 1, cell.z)))
	neighbors.append(Vector3i(cell.x, cell.y + 1, cell.z))
	neighbors.append_array(get_cell_neighbors(Vector3i(cell.x, cell.y + 1, cell.z)))
	return neighbors


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


func get_cell_quad_neighbors(cell: Vector3i) -> Array[Vector3i]:
	var neighbors : Array[Vector3i] = [
		Vector3i(cell.x + 1, cell.y, cell.z),
		Vector3i(cell.x, cell.y, cell.z + 1),
		Vector3i(cell.x - 1, cell.y, cell.z),
		Vector3i(cell.x, cell.y, cell.z - 1)
	]
	return neighbors
#endregion
