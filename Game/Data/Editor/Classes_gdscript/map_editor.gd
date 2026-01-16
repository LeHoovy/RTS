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

#@export_tool_button("Create new map", "Callable") var gen_map : Callable = _new_map
@export var window_size := Vector2(500, 720)
@export var map_storage_path := String("res://Game/Data/Editor/Maps/")

const CREATE_MAP_DIALOGUE = preload("uid://bko3lfheh3efu")


# Contains points on the map and what other points they are connected to
# i.e a point at (0, 0, 0) could connect to (2, 0, 0), (0, 2, 0), and (0, 0, 2)
# Essentially just the corners found on the map
# Should be useful for generating meshes and navmeshes
# Should contain ramps, or at least points where ramps might connect
#var scene_root: Node
#var _map_corners: Dictionary[Vector3, Array]
#var _map: Map
#var _editor_cam: Camera3D
#var _editor_viewport: Viewport
var map_creation_output: Dictionary[String, Variant]
var mouse_tracker: Node3D
var chunks: Array[Node3D]
var terrain_brush_active := false:
	get:
		return terrain_brush_active
	set(new_val):
		terrain_brush_active = new_val
		print("Brush status changed to ", terrain_brush_active)
		mouse_tracker.visible = new_val


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
	new_map_window.visible = false
	if Engine.is_editor_hint():
		EditorInterface.popup_dialog(new_map_window, Rect2i(position_finder.position, window_size))
	else:
		add_child(new_map_window)
		new_map_window.popup(Rect2i(position_finder.position, window_size))
	
	position_finder.queue_free()
	
	new_map_window.close_requested.connect(func() -> void:
		new_map_window.queue_free()
	) # Close window on cancel code block
	
	var creation_panel := CREATE_MAP_DIALOGUE.instantiate() as MapCreationDialogue
	creation_panel.create_map.connect(create_new_map)
	
	new_map_window.add_child(creation_panel)


# Generates new map mesh and collider
func create_new_map(map_details: Dictionary[String, Variant]) -> void:
	#var map_size: Vector3i = map_creation_output["Size"]
	
	var map_name: String = str(map_details["Name"])
	var map_path: String = map_storage_path.path_join(map_name)
	var new_map: FileAccess
	if not DirAccess.dir_exists_absolute(map_path):
		var new_folder_test: Error = DirAccess.make_dir_recursive_absolute(map_path)
		if new_folder_test != Error.OK:
			printerr(error_string(new_folder_test) + "! Could not create map folder.")
	
	var new_map_data := JSON.stringify(map_details, "\t", false)
	new_map = FileAccess.open(map_path.path_join("map.JSON"), FileAccess.WRITE)
	new_map.store_string(new_map_data)
	new_map.close()
	
	EditorData.current_map_path = map_path

	#var heightmap := HeightmapHandler.new(Vector2i(map_size.x, map_size.y))
	#HeightmapHandler.gen_new_heightmap(map_size.z)
	
	#var generator := MapGenerator.new()
	#generator.map = _map
	#generator.scene_root = scene_root
	#
	#generator.new_map(map_size)


func _ready() -> void:
	#_map = %Map
	#scene_root = get_node("/root").get_child(0)
	#if Engine.is_editor_hint():
		#_editor_viewport = EditorInterface.get_editor_viewport_3d()
		#_editor_cam = _editor_viewport.get_camera_3d()
	#else:
	#_editor_viewport = get_viewport()
	#_editor_cam = _editor_viewport.get_camera_3d()
	
	mouse_tracker = %MouseTracker
	_new_map()
