class_name EditorCamera
extends Node3D


const RADIAN: float = 2 * PI


var _rotating_camera := false
var _camera_rotation_speed: float = 100.0
var _moving_camera := false
var _camera_move_speed: float = 0.5
var _rotation_x: float = 0.0
var _rotation_y: float = 0.0
var _map: MapEditor


func _ready() -> void:
	_map = get_parent().get_node("MapEditor") as MapEditor


## Handles camera rotation
func _rotate_cam(mouse_movement: InputEventMouseMotion) -> void:
	_rotation_x += mouse_movement.relative.x * -(1 / _camera_rotation_speed)
	if _rotation_x < 0:
		_rotation_x += RADIAN
	elif _rotation_x > RADIAN:
		_rotation_x -= RADIAN
	
	_rotation_y += mouse_movement.relative.y * -(1 / _camera_rotation_speed)
	if _rotation_y > RADIAN / 8:
		_rotation_y = RADIAN / 8
	elif _rotation_y < -RADIAN / 9:
		_rotation_y = -RADIAN / 9
	
	transform.basis = Basis()
	rotate_object_local(Vector3(0, 1, 0), _rotation_x)
	rotate_object_local(Vector3(1, 0, 0), _rotation_y)
	
	if (get_node("Vertical Rotation/Camera") as Camera3D).global_position.y < 0:
		print("Camera below ground")


## Handles camera movement
func _move_cam(mouse_movement: InputEventMouseMotion) -> void:
	var movement_horizontol := mouse_movement.relative.x
	var movement_vertical := mouse_movement.relative.y
	var movement := Vector3(
			mouse_movement.relative.x,
			0,
			mouse_movement.relative.y,
	)
	movement *= transform.basis
	
	global_translate(Vector3(movement_horizontol, 0, movement_vertical))


func _input(event: InputEvent) -> void:
	# Enable/disable camera rotation if the correct button is held
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				_rotating_camera = true
				_map.terrain_brush_active = false
				print("Allowing camera rotation")
			else:
				_rotating_camera = false
				_map.terrain_brush_active = true
				print("Disallowing camera rotation")
		
	# Enable/disable camera movement if the correct button is held
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_XBUTTON2:
			if event.is_pressed():
				_moving_camera = true
				_map.terrain_brush_active = false
				print("Allowing camera movement")
			else:
				_moving_camera = false
				_map.terrain_brush_active = true
				print("Disallowing camera movement")
	
	# If the event is mouse movement, and we're allowing rotation, rotate the camera
	if _rotating_camera and event is InputEventMouseMotion:
		_rotate_cam(event as InputEventMouseMotion)
	
	# If the event is mouse movement, and we're allowing movement, translate the camera
	if _moving_camera and event is InputEventMouseMotion:
		_move_cam(event as InputEventMouseMotion)
