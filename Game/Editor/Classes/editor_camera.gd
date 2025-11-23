class_name EditorCamera
extends Node3D

## TODO:
# Handle adjustment of rotation speed, movement speed, and zoom speed


const RADIAN: float = 2 * PI

@export var camera_rotation_speed: float = 100.0
@export var camera_move_speed: float = 0.25
@export var min_zoom: float
@export var max_zoom: float
@export var zoom_speed: float

var _map_editor: MapEditor
var _camera: Camera3D
var _map_data: MapData

var _rotating_camera := false
var _moving_camera := false
var _rotation_x: float = 0.0
var _rotation_y: float = 0.0
var _zoom: float


func _ready() -> void:
	_map_editor = %MapEditor
	_camera = $Lock/Camera
	_zoom = _camera.position.y
	_map_data = %MapData
	
	_zoom = _camera.position.y * 5


## Handles camera rotation
func _rotate_cam(mouse_movement: InputEventMouseMotion) -> void:
	_rotation_x += mouse_movement.relative.x * -(1 / camera_rotation_speed)
	if _rotation_x < 0:
		_rotation_x += RADIAN
	elif _rotation_x > RADIAN:
		_rotation_x -= RADIAN
	
	_rotation_y += mouse_movement.relative.y * -(1 / camera_rotation_speed)
	if _rotation_y > RADIAN / 8:
		_rotation_y = RADIAN / 8
	elif _rotation_y < -RADIAN / 9:
		_rotation_y = -RADIAN / 9
	
	transform.basis = Basis()
	rotate_object_local(Vector3(0, 1, 0), _rotation_x)
	rotate_object_local(Vector3(1, 0, 0), _rotation_y)
	
	if _camera.global_position.y < 0:
		print("Camera below ground")


## Handles camera movement
func _move_cam(mouse_movement: InputEventMouseMotion) -> void:
	var movement_horizontal := transform.basis.x * mouse_movement.relative.x
	movement_horizontal.y = 0
	var movement_vertical := transform.basis.z * mouse_movement.relative.y
	movement_vertical.y = 0
	
	var movement := Vector3(movement_horizontal + movement_vertical)
	
	# Handles horizontal movement
	global_translate(movement * camera_move_speed / (1 / (_zoom / 500)))
	stay_over_map()


## Make sure the camera doesn't move off of the map
func stay_over_map() -> void:
	# Can't move too far horizontally
	if position.x > _map_data.map_size.x / 2 + 4: # East
		position.x = _map_data.map_size.x / 2 + 4
	if position.x < -_map_data.map_size.x / 2 - 4: # West
		position.x = -_map_data.map_size.x / 2 - 4
	
	# Can't move too far vertically
	if position.z > _map_data.map_size.y / 2 + 4: # North
		position.z = _map_data.map_size.y / 2 + 4
	if position.z < -_map_data.map_size.y / 2 - 4: # South
		position.z = -_map_data.map_size.y / 2 - 4


func _change_zoom(zoom_change: int) -> void:
	_zoom += zoom_change
	if _zoom > max_zoom:
		_zoom = max_zoom
	elif _zoom < min_zoom:
		_zoom = min_zoom
	
	_camera.position.y = _zoom / 5


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Enable/disable camera rotation if the correct button is held
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				_rotating_camera = true
				_map_editor.terrain_brush_active = false
				print("Allowing camera rotation")
			else:
				_rotating_camera = false
				_map_editor.terrain_brush_active = true
				print("Disallowing camera rotation")
			
		# Enable/disable camera movement if the correct button is held
		if (
					(event as InputEventMouseButton).button_index == MOUSE_BUTTON_XBUTTON2
					or (event as InputEventMouseButton).button_index == MOUSE_BUTTON_MIDDLE
			):
			if event.is_pressed():
				_moving_camera = true
				_map_editor.terrain_brush_active = false
				print("Allowing camera movement")
			else:
				_moving_camera = false
				_map_editor.terrain_brush_active = true
				print("Disallowing camera movement")
			
		# Zoom in and out
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_UP:
			_change_zoom(-zoom_speed)
		elif (event as InputEventMouseButton).button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_change_zoom(zoom_speed)
		
	# If the event is mouse movement, and we're allowing rotation, rotate the camera
	if _rotating_camera and event is InputEventMouseMotion:
		_rotate_cam(event as InputEventMouseMotion)
	
	# If the event is mouse movement, and we're allowing movement, translate the camera
	if _moving_camera and event is InputEventMouseMotion:
		_move_cam(event as InputEventMouseMotion)
