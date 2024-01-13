extends MeshInstance3D
class_name Triangle_Mesh

#region Setup
var vertices : Array[Vector3]
var color : StandardMaterial3D
#var outline: StandardMaterial3D
#endregion

# Called when the node enters the scene tree for the first time.
#region doesn't really work yet :/
func _ready() -> void:
	color = StandardMaterial3D.new()
	#outline = StandardMaterial3D.new()
	color.albedo_color = Color(0, 1, 1.2, 0.25)
	#color.transparency = 1
	
	#outline.grow = true
	#outline.grow = -1
	#outline.cull_mode = 1
	#outline.albedo_color = Color(0, 0, 0, 1)
	#color.set_next_pass(outline)
	
	#gen_mesh()
	#set_surface_override_material(0, color)
#endregion


func set_surface(surface : int, rgb_color : Color) -> void:
	color.albedo_color = rgb_color
	set_surface_override_material(surface, color)

#region mesh generation
func gen_mesh() -> void:
	var array_mesh : ArrayMesh = ArrayMesh.new()
	var packed_vertices : PackedVector3Array
	packed_vertices.append_array(vertices)
	
	var indices : PackedInt32Array
	for indice in range(packed_vertices.size()):
		indices.append(indice)
	
	var array : Array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = packed_vertices
	array[Mesh.ARRAY_INDEX] = indices
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	mesh = array_mesh
	
	#array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, array)


func gen_outline() -> void:
	var array_mesh : ArrayMesh = ArrayMesh.new()
	var packed_vertices : PackedVector3Array
	for i in range(vertices.size(), 0, -1):
		packed_vertices.append(vertices[i - 1])
		packed_vertices.append(vertices[i - 2])
	
	var indices := PackedInt32Array(
		range(packed_vertices.size())
	)
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
