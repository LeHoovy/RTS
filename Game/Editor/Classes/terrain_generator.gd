@tool
class_name TerrainGenerator
extends Node


const MATERIAL: Material = preload("uid://bgd2s5biaripg")
var map_mesh: MeshInstance3D


# generates the new map mesh
func generate_new_map(map_size: Vector2, _position: Vector2, requested_sides: int = 4) -> void:
	# Mesh setup preperation
	var corners: Array[Vector2] = [
			Vector2(-map_size.x / 2, -map_size.y / 2),
			Vector2(map_size.x / 2, -map_size.y / 2),
			Vector2(map_size.x / 2, map_size.y / 2),
			Vector2(-map_size.x / 2, map_size.y / 2),
	]
	var normal := Vector3(0, 1, 0)
	map_mesh.mesh = ArrayMesh.new()
	
	var surface_tool := SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# works for squares, not sure about other shapes
	for i in range(requested_sides - 2):
		for corner in range(3):
			surface_tool.set_normal(normal)
			surface_tool.add_vertex(
					Vector3(corners[corner].x, 0, corners[corner].y)
			)
		
		corners.pop_at(1)
	
	surface_tool.commit(map_mesh.mesh as ArrayMesh)
	map_mesh.set_surface_override_material(0, MATERIAL)
	
	queue_free()
