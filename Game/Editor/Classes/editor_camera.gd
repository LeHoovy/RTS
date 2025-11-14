class_name EditorCamera
extends Node3D


var _rotating_camera: bool = false
var _camera_move_speed := 10.0


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
		pass
