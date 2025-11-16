class_name EditorCamera
extends Node3D


const RADIAN: float = 2 * PI


var _rotating_camera := false
var _camera_rotation_speed: float = 100.0
var _moving_camera := false
var _camera_move_speed: float = 10.0
var _rotation_x: float = 0.0
var _rotation_y: float = (RADIAN / 8)


func _ready() -> void:
	rotate_object_local(Vector3(0, 1, 0), 0)
	rotate_object_local(Vector3(1, 0, 0), _rotation_y)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (event as InputEventMouseButton).button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				_rotating_camera = true
				print("Allowing camera movement")
			else:
				_rotating_camera = false
				print("Disallowing camera movement")
	
	if _rotating_camera and event is InputEventMouseMotion:
		_rotation_x += (event as InputEventMouseMotion).relative.x * -(1 / _camera_rotation_speed)
		if _rotation_x < 0:
			_rotation_x += RADIAN
		elif _rotation_x > RADIAN:
			_rotation_x -= RADIAN
		
		_rotation_y += (event as InputEventMouseMotion).relative.y * -(1 / _camera_rotation_speed)
		if _rotation_y > RADIAN / 4:
			_rotation_y = RADIAN / 4
		elif _rotation_y < (RADIAN / 128):
			_rotation_y = (RADIAN / 128)
		
		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), _rotation_x)
		rotate_object_local(Vector3(1, 0, 0), _rotation_y)
		
		if (get_node("Camera") as Camera3D).global_position.y < 0:
			print("Camera below ground")
