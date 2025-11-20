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
var _map: MeshInstance3D
var _editor_cam: Camera3D
var _editor_viewport: Viewport
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
	EditorInterface.popup_dialog(new_map_window, Rect2i(position_finder.position, window_size))
	position_finder.queue_free()
	
	new_map_window.close_requested.connect(func() -> void:
		new_map_window.queue_free()
	) # Close window on cancel code block
	
	new_map_window.add_child(CREATE_MAP_DIALOGUE.instantiate())

# Generates new map mesh and collider
func generate_new_map(map_size: Vector2) -> void:
	# Makes sure that the new map doesn't already have a collider
	for child in _map.get_children():
		if child is StaticBody3D:
			child.queue_free()
	
	# Generate's the new maps basic mesh
	var map_gen := TerrainGenerator.new()
	map_gen.map_mesh = _map
	map_gen.generate_new_map(map_size, Vector2(0, 0))
	
	# Double await to make sure the name of the new StaticBody3D is always the same
	await get_tree().process_frame
	await get_tree().process_frame
	_map.create_trimesh_collision()
	
	var collider: StaticBody3D
	for child in _map.get_children():
		if child is StaticBody3D:
			collider = child
	
	collider.set_collision_mask_value(1, false)
	collider.set_collision_layer_value(1, false)
	collider.set_collision_layer_value(32, true)
	print(collider.collision_layer)
	print(collider.collision_mask)


func _ready() -> void:
	_map = get_parent().get_node("Map")
	if Engine.is_editor_hint():
		_editor_viewport = EditorInterface.get_editor_viewport_3d()
		_editor_cam = _editor_viewport.get_camera_3d()
	else:
		_editor_viewport = get_viewport()
		_editor_cam = _editor_viewport.get_camera_3d()
	
	mouse_tracker = get_parent().get_node("Mouse Tracker")
