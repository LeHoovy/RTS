extends GridMap
class_name MapClient

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

	#performance.IsPathable(all_cells)
