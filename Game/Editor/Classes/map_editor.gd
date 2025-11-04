@tool
class_name MapEditor
extends Node3D
# TODO:
# Make a chunk system
# Chunk up map corners, so the chunks hold regions of the map
# Send map corners to navmesh generator
# Navigation will be unrelated to chunks, but chunks will be used for performance in rendering
# 
# Chunks should probably have their own classes
# If chunks are their own classes, instances, or even scenes, might not need this to extend Node3D

@export_tool_button("Create new map", "Callable") var gen_map : Callable = _new_map
@export var window_size := Vector2(500, 720)

const CREATE_MAP_DIALOGUE = preload("uid://bko3lfheh3efu")


# Contains points on the map and what other points they are connected to
# i.e a point at (0, 0, 0) could connect to (2, 0, 0), (0, 2, 0), and (0, 0, 2)
# Essentially just the corners found on the map
# Should be useful for generating meshes and navmeshes
# Should contain ramps, or at least points where ramps might connect
var _map_corners: Dictionary[Vector3, Array]
var chunks: Array[Node3D]
var _map: Map


# Open the new map creation dialog when generate map is pressed
func _new_map() -> void:
	# position_finder is generated at the same size as the new editor window at the center
	# its position is then taken for the new editor window and used
	var position_finder := Window.new()
	position_finder.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_OTHER_SCREEN
	position_finder.size = window_size
	add_child(position_finder)
	
	# Generate the new map window prompt and create it in the editor
	# Free the position finder's memory afterwards
	var new_map_window := Window.new()
	EditorInterface.popup_dialog(new_map_window, Rect2i(position_finder.position, window_size))
	position_finder.queue_free()
	
	new_map_window.close_requested.connect(func() -> void:
		new_map_window.queue_free()
	) # Close window on cancel code block
	
	new_map_window.add_child(CREATE_MAP_DIALOGUE.instantiate())


func make_new_map(map_size: Vector2) -> void:
	var map_gen := MapGenerator.new()
	map_gen.editor = self
	map_gen.generate_new_map(map_size, 4)
	#var corners: Array[Vector2] = [
			#Vector2(-map_size.x / 2, -map_size.y / 2),
			#Vector2(map_size.x / 2, -map_size.y / 2),
			#Vector2(map_size.x / 2, map_size.y / 2),
			#Vector2(-map_size.x / 2, map_size.y / 2),
	#]
	#
	## VERY TEMPORARY CHANGE LATER
	#var temp_corners: Array[Vector3] = [
			#Vector3(corners[0].x, 0, corners[0].y),
			#Vector3(corners[1].x, 0, corners[1].y),
			#Vector3(corners[2].x, 0, corners[2].y),
			#Vector3(corners[3].x, 0, corners[3].y),
	#]
	#var temp_mesh_corners := PackedVector3Array(temp_corners)
	#var temp_mesh_indices := PackedInt32Array(
		#[
			#0, 1, 2,
			#0, 2, 3,
		#]
	#)
	#
	## TEMPORARY CHANGE THIS LATER
	#var temp_nochunk_map_mesh := ArrayMesh.new()
	#var temp_map_mesh_instance := get_node("MeshInstance3D") as MeshInstance3D
	#temp_map_mesh_instance.mesh = temp_nochunk_map_mesh
	#
	#var temp_surface_array: Array[Variant] = []
	#temp_surface_array.resize(Mesh.ARRAY_MAX)
	#
	#temp_surface_array[Mesh.ARRAY_VERTEX] = temp_mesh_corners
	#temp_surface_array[Mesh.ARRAY_INDEX] = temp_mesh_indices
	#
	#temp_nochunk_map_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, temp_surface_array)
