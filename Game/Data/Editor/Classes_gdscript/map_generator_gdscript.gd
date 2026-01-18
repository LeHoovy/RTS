class_name MapGeneratorGDScript
extends RefCounted


var scene_root: Node
var map: Map
var _chunk_size: int = 8 # Size of each chunk in tiles on one axis. Chunks are square.


func _generate_chunk(chunk_pos: Vector2i, chunk_height: int) -> MapChunkGDScript:
	#print(chunk_pos)
	return


func new_map(map_size: Vector3i) -> void:
	for x: int in map_size.x / _chunk_size:
		for y: int in map_size.y / _chunk_size:
			_generate_chunk(Vector2i(x, y), map_size.z)
	
	# OLD STUFF
	# Generate's the new maps basic mesh
	#var map_gen := TerrainGenerator.new()
	#map_gen.gen_mesh(map_size, Vector2(0, 0))
	
	# Old stuff but still useful
	#_map.create_trimesh_collision()
	#
	#var collider: StaticBody3D
	#for child in _map.get_children():
		#if child is StaticBody3D:
			#collider = child
	#
	#collider.set_collision_mask_value(1, false)
	#collider.set_collision_layer_value(1, false)
	#collider.set_collision_layer_value(32, true)
