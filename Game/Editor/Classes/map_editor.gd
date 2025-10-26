#@tool
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

#@export_tool_button("Generate debug map", "Callable") var gen_map : Callable = debug_gen_map

const CREATE_MAP_DIALOGUE = preload("uid://bko3lfheh3efu")


# Contains points on the map and what other points they are connected to
# i.e a point at (0, 0, 0) could connect to (2, 0, 0), (0, 2, 0), and (0, 0, 2)
# Essentially just the corners found on the map
# Should be useful for generating meshes and navmeshes
# Should contain ramps, or at least points where ramps might connect
var _map_corners: Dictionary[Vector3, Array]
var chunks: Array[Node3D]
var _map: Map
var _new_map_window: Window

func _debug_gen_new_map_window() -> void:
	if _new_map_window != null:
		print("Window exists!")
		_new_map_window.queue_free()
		await get_tree().process_frame
	else:
		print("Window does not exist!")
	
	_new_map_window = CREATE_MAP_DIALOGUE.instantiate()
	add_child(_new_map_window)
	_new_map_window.owner = get_tree().edited_scene_root
	await get_tree().process_frame
	
	print(_new_map_window)
	print("test")
