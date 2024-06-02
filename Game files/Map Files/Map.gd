extends GridMap
class_name Map

@export_node_path("CSMapPerformer") var perf_booster: NodePath
var performance: CSMapPerformer


func _ready() -> void:
	performance = get_node(perf_booster) as CSMapPerformer
	
	var all_cells: Array[Vector3i] = get_used_cells()

	#performance.IsPathable(all_cells)
