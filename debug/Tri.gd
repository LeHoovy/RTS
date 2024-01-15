extends MeshInstance3D
class_name Triangle_Mesh

#region Setup
var vertices : Array[Vector3]
var main := StandardMaterial3D.new()
var outline := StandardMaterial3D.new()
var array_mesh : ArrayMesh = ArrayMesh.new()
#endregion

# Called when the node enters the scene tree for the first time.
#region doesn't really work yet :/
func _ready() -> void:
	main.albedo_color = Color(0, 1.1, 1.3, 0.4)
	main.transparency = main.TRANSPARENCY_ALPHA
	outline.transparency = outline.TRANSPARENCY_ALPHA
	outline.albedo_color = Color(0, 0.1, 0.5, 0.6)
	#outline.cull_mode = outline.CULL_FRONT
	#outline.grow = true
	#outline.grow = -1
	#outline.cull_mode = 1
	#outline.albedo_color = Color(0, 0, 0, 1)
	#main.set_next_pass(outline)
	
	#gen_mesh()
	#set_surface_override_material(0, main)
#endregion


func set_surface(surface : int, rgb_color : Color, opaque : int = 1) -> void:
	main.transparency = opaque
	main.albedo_color = rgb_color
	set_surface_override_material(surface, main)

#region mesh generation
func gen_main() -> void:
	var packed_vertices : PackedVector3Array
	for i in vertices:
		packed_vertices.append(Vector3(i.x * 0.95, i.y + 0.1, i.z * 0.95))
	
	var indices : PackedInt32Array
	for indice in range(packed_vertices.size()):
		indices.append(indice)
	
	var array : Array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = packed_vertices
	array[Mesh.ARRAY_INDEX] = indices
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	
	
	
	#array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, array)


func gen_outline() -> void:
	#var array_mesh : ArrayMesh = ArrayMesh.new()
	var packed_vertices : PackedVector3Array
	for i in vertices:
		packed_vertices.append(i)
	
	var indices := PackedInt32Array(
		range(packed_vertices.size())
	)
	
	var array : Array = []
	array.resize(Mesh.ARRAY_MAX)
	array[Mesh.ARRAY_VERTEX] = packed_vertices
	array[Mesh.ARRAY_INDEX] = indices
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, array)
	
	
	


func gen_mesh() -> void:
	mesh = array_mesh
	set_surface_override_material(0, main)
	#set_surface_override_material(1, outline)
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
