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
	# position_finder is generated at the same size as the new editor window at the center
	# its position is then taken for the new editor window and used
	var position_finder := Window.new()
	position_finder.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_OTHER_SCREEN
	position_finder.size = Vector2(500, 720)
	add_child(position_finder)
	
	# Generate the new map window prompt and create it in the editor
	# Free the position finder's memory afterwards
	var new_map_window := Window.new()
	EditorInterface.popup_dialog(new_map_window, Rect2i(position_finder.position, Vector2(500, 720)))
	position_finder.queue_free()
	
	new_map_window.close_requested.connect(func() -> void:
		new_map_window.queue_free()
	)
	
	new_map_window.add_child(CREATE_MAP_DIALOGUE.instantiate())
