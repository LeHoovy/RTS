extends MeshInstance3D
class_name Triangle

#region Setup
var points: Array[Vector3]
#endregion

# Called when the node enters the scene tree for the first time.
#region doesn't really work yet :/
func _ready() -> void:
	gen_mesh()


func gen_mesh() -> void:
	var array_mesh: ArrayMesh = ArrayMesh.new()
	var vertices := PackedVector3Array(
		[
			points[0],
			points[1],
			points[2]
		]
	)
	
	var indices := PackedInt32Array(
		[
			0, 1, 2
		]
	)
	
	var array: Array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = vertices
	array[Mesh.ARRAY_INDEX] = indices
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = array_mesh


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
