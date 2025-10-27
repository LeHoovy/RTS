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

@export_tool_button("Generate debug map", "Callable") var gen_map : Callable = _debug_gen_new_map_window

const CREATE_MAP_DIALOGUE = preload("uid://bko3lfheh3efu")


# Contains points on the map and what other points they are connected to
# i.e a point at (0, 0, 0) could connect to (2, 0, 0), (0, 2, 0), and (0, 0, 2)
# Essentially just the corners found on the map
# Should be useful for generating meshes and navmeshes
# Should contain ramps, or at least points where ramps might connect
var _map_corners: Dictionary[Vector3, Array]
var chunks: Array[Node3D]
var _map: Map

func _debug_gen_new_map_window() -> void:
	var new_map_window := Window.new()
	#var position_finder := Window.new()
	#position_finder.initial_position = WINDOW_INITIAL_POSITION_CENTER_OTHER_SCREEN
	#add_child(position_finder)
	# Replace Rect2i(Vector2(100, 100),) with Rect2i(position_finder.position)
	#position_finder.queue_free()
	EditorInterface.popup_dialog(new_map_window, Rect2i(Vector2(100, 100), Vector2(500, 720)))
	
	new_map_window.close_requested.connect(func() -> void:
		new_map_window.queue_free()
	)
	
	new_map_window.add_child(CREATE_MAP_DIALOGUE.instantiate())
