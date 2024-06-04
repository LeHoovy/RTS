extends GridMap
class_name MapClient

var camera_client: Node3D

var performance: CSMapPerformer
@export var load_map: String
var map: MapServer

const directions: Array[int] = [
	22, # east
	10, # south
	16, # west
	0 # north
]

func _ready() -> void:
	if get_used_cells():
		clear()
	else:
		print('Already empty!')
	map = (load(load_map) as PackedScene).instantiate()
	map.visible = false
	camera_client = get_parent().get_node("Camera")
	add_child(map)
	
	#map.used_tiles()
	
	for child in get_children():
		if child is CSMapPerformer:
			performance = child
			print('Performance node found')
			break
	if performance == null:
		printerr('No performance node found')
	
	var all_cells: Array[Vector2i] = map.used_tiles() #May need to also have a Vector3i version
	
	for cell in all_cells:
		var cell_type: Vector2i = map.get_cell_type_dir(cell) 
		set_cell_item(map.get_cell_height(cell), cell_type.x, directions[cell_type.y % 4])
	
	for cell in range(all_cells.size(), 0, -1):
		fix_floating(map.get_cell_height(all_cells[cell - 1]))
	
	camera_client = get_parent().get_node("Camera")



func fix_floating(cell_check: Vector3i) -> void:
	for cell_y in range(cell_check.y, 0, -1):
		if cell_is_visibly_floating(Vector3i(cell_check.x, cell_y - 1, cell_check.z)):
			set_cell_item(Vector3i(cell_check.x, cell_y - 1, cell_check.z), 0)
		else:
			set_cell_item(Vector3i(cell_check.x, cell_y - 1, cell_check.z), -1)



func cell_is_visibly_floating(cell: Vector3i) -> bool:
	if get_cell_item(Vector3i(cell.x + 1, cell.y, cell.z)) == -1:
		return true
	if get_cell_item(Vector3i(cell.x, cell.y, cell.z + 1)) == -1:
		return true
	if get_cell_item(Vector3i(cell.x - 1, cell.y, cell.z)) == -1:
		return true
	return false
