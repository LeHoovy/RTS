extends Node2D
class_name Camera2DServer

@export_category("Sensitivity")
@export_range(1, 100) var edge_scroll_sens : int = 10
@export var smooth_cam_move : bool = false
@export_range(0.01, 3) var smooth_cam_time : float = 0.5
@export var drag_sens : float = 4
@export_range(0.1, 10, 0.1) var move_margin : float = 1

var parent: MapServer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	parent = get_parent()
	camera_client = (parent.get_parent() as MapClient).camera_client


#region General Functions
var camera_client: Node3D
var mouse_pos : Vector2
var screen_size : Vector2
var cam_move_speed : Vector2
func is_mouse_on_edge(percentage : float) -> Vector2i:
	var output : Vector2i = Vector2i(0, 0)
	if mouse_pos.x <= (percentage / 100) * screen_size.x:
		output.x = -1
	elif mouse_pos.x >= (screen_size.x * (percentage / 100) + screen_size.x - (((percentage / 100) * screen_size.x) * 2) - 1):
		output.x = 1
	if mouse_pos.y <= (percentage / 100) * screen_size.y:
		output.y = -1
	elif mouse_pos.y >= (screen_size.y * (percentage / 100) + screen_size.y - (((percentage / 100) * screen_size.y) * 2) - 1):
		output.y = 1
	#print((percentage / 100) * screen_size.x)
	#print(screen_size.x * (percentage / 100) + screen_size.x - (((percentage / 100) * screen_size.x) * 2))
	#print(mouse_pos, screen_size)
	#print(mouse_pos.y <= (percentage / 100) * screen_size.y)
	return output

var not_delta : Vector2
var friction : float = 0.9
var move : Vector2i
func process_move(delta : float) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	screen_size = get_viewport().get_visible_rect().size
	move = is_mouse_on_edge(move_margin)
	if smooth_cam_move:
		calc_move(delta)
	else:
		cam_move_speed = move * edge_scroll_sens
	
	position += cam_move_speed * delta

func calc_move(delta : float) -> void:
	#mouse_pos = get_viewport().get_mouse_position()
	#screen_size = get_viewport().get_visible_rect().size
	#move = is_mouse_on_edge(1)
	cam_move_speed += move * (edge_scroll_sens * delta * 2)
	#cam_move_speed *= friction
	cam_move_speed = cam_move_speed.clamp(Vector2(-edge_scroll_sens, -edge_scroll_sens), Vector2(edge_scroll_sens, edge_scroll_sens))
	
	if move.x == 0:
		cam_move_speed.x = 0
	if move.y == 0:
		cam_move_speed.y = 0
	
	#print(cam_move_speed)
	position += cam_move_speed * delta
#endregion

func _process(delta : float) -> void:
	process_move(delta)
	camera_client.position.x = position.x
	camera_client.position.z = position.y
	camera_client.position.y = parent.get_cell_height(Vector2i(roundi(position.x), roundi(position.y))).y + 1
	calc_height()

#region General Functions 2


var zoomSpeed : float = 0.05
var zoomMin : float = 0.3
var zoomMax : float = 5.0
var zoom : float = 1
#Sets the minimum and maximum zoom, as well as the speed of zooming.

#Changes the sensitivity of the ability to drag around the camera.

func _input(event : Variant) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position.x -= event.relative.x / 49.5
		position.y -= event.relative.y / 50
#Repositions the camera as long as the middle mouse button (mouse 3) is pressed
#Relative to the sensitivity and movement of the mouse.
#Also adjusts based on the zoom amount.
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += zoomSpeed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= zoomSpeed
		#Changes zoom as long, and only if, the mouse wheel is being scrolled
		zoom = clamp(zoom, zoomMin, zoomMax)


#const ray_length: int = 2000
#func _physics_process(delta):
	#var physic_proc_mouse_pos = get_viewport().get_mouse_position()
	#var from: Vector3 = $Camera3D.project_ray_origin(physic_proc_mouse_pos)
	#var to: Vector3 = from + $Camera3D.project_ray_normal(physic_proc_mouse_pos) * ray_length
	#var space: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	#var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	#ray_query.from = from
	#ray_query.to = to
	#ray_query.collide_with_areas = true
	#var raycast_result: Dictionary = space.intersect_ray(ray_query)
	#
	#if not raycast_result.is_empty():
		#print("Not empty")
		#var pos: Vector3 = raycast_result.position
		#var look_at_me: Vector3 = Vector3(pos.x, $Player.position.y, pos.z)
		#$Player.look_at(look_at_me, Vector3.UP)
#endregion

const max_tile_dist: int = 100
func calc_height() -> float:
	var closest_tiles: Array[float] = []
	print(closest_tiles) #may need to change back from normalized to non-normalized, but normalized should be good for now
	#print(tile_true_positions)
	get_overlapping_tiles()
	return 0.0

# TODO: get what percent each tile is covered by, when positions are equal (i.e 50,50), should be 100%, when in a perfect corner (i.e 0,0), it should be 25%
const tile_size_px: int = 100
func get_overlapping_tiles(radius: float = 50) -> Array[float]:
	var tiles_arr: Array[Vector2]
	for x in range(0 - radius, radius + 1, tile_size_px):
		for y in range(0 - radius, radius + 1, tile_size_px):
			if not tiles_arr.has(parent.map_to_local(parent.local_to_map(
				Vector2(x + position.x, y + position.y)
			))):
					tiles_arr.append(parent.map_to_local(parent.local_to_map(Vector2(
						x + position.x, y + position.y
					))))
	print(tiles_arr)
	var tiles_dist: Array[Vector2]
	for tile in tiles_arr:
		tiles_dist.append(
			Vector2(position - tile).abs()
		)
	print(tiles_dist)
	return []
