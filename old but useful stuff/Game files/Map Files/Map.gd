extends GridMap
class_name MapOld



func _ready() -> void:
	var _all_cells: Array[Vector3i] = get_used_cells()

	#performance.IsPathable(all_cells)
