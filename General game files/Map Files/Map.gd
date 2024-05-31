extends GridMap
class_name Map

#region Inspector variables
@export var open_ceilings : Array[int] = [-1]
@export var neighbor_but_edge : Array[int]
#endregion

var thread : Thread
var edges : Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	bake_navmesh()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass


#region Basically, "hey is there anything above me" and "am I an edge"
func check_for_ceiling(cell: Vector3i) -> bool:
	if open_ceilings.has(get_cell_item(Vector3i(cell.x, cell.y + 1, cell.z))):
		return false
	return true


func find_if_cell_edges(target : Vector3i) -> Array[bool]:
	var output : Array[bool] = [false, false, false, false]
	var iteration : int = 0
	for neighbor in get_neighbor(target):
		if neighbor_but_edge.has(neighbor):
			output.remove_at(iteration)
			output.insert(iteration, true)
		iteration += 1
	iteration = 0
	for neighbor in get_neighbor(Vector3i(target.x, target.y + 1, target.z)):
		if neighbor_but_edge.has(neighbor) and output[iteration] == false:
			output.remove_at(iteration)
			output.insert(iteration, true)
		iteration += 1
	return output


func bake_navmesh() -> void:
	for cell in get_used_cells():
		if check_for_ceiling(cell):
			continue
		find_if_cell_edges(cell)
	pass


func get_neighbor(current : Vector3i) -> Array[Vector3i]:
	return [
		Vector3i(current.x + 1, current.y, current.z),
		Vector3i(current.x, current.y, current.z + 1),
		Vector3i(current.x - 1, current.y, current.z),
		Vector3i(current.x, current.y, current.z - 1)
	]
