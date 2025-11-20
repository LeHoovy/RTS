class_name MouseTracker
extends Node3D


var _camera: Camera3D
var _viewport: Viewport
var _map: MeshInstance3D


func _ready() -> void:
	_map = get_parent().get_node("Map") as MeshInstance3D
	_viewport = get_viewport()
	_camera = _viewport.get_camera_3d()


func _process(delta: float) -> void:
	var collision_pos: Vector3
	var collided: bool = false
	#if terrain_brush_active:
	# ALL of this is just setting up the raycast
	# From and to are self explanatory, the query is just the ray settings
	# Space state is used for collisions
	var from: Vector3 = _camera.project_ray_origin(_viewport.get_mouse_position())
	var to: Vector3 = from + _camera.project_ray_normal(_viewport.get_mouse_position()) * 1000
	var query := PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = 2147483648
	var space_state := get_world_3d().direct_space_state
	
	# Perform the raycast and store the results.
	# If we sucessfully collided with the map, make that known
	var result: Dictionary = space_state.intersect_ray(query)
	if result.size() > 0:
		collision_pos = result.get("position")
		if result.get("collider") == _map.get_node("Map_col"):
			collided = true
	
	if collided:
		position = Vector3(collision_pos.x, collision_pos.y + 0.5, collision_pos.z)
