extends Node3D

var rayOrigin = Vector3()
var rayTarget = Vector3()

func _process(delta):
	
	var mousePos = get_viewport().get_mouse_position()
#	print("Mouse Position: ", mousePos)
	
	var rayOrigin = $Camera3D.project_ray_origin(mousePos)
#	print("rayOrigin: ", rayOrigin)
	rayTarget = rayOrigin + $Camera3D.project_ray_normal(mousePos) * 2000
	
	var spaceState = get_world_3d().direct_space_state
	var parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayTarget)
	var intersect = spaceState.intersect_ray(parameters)
	
	if Input.is_action_just_pressed("MB2"):
		if not intersect.is_empty():
			print("NOT EMPTY!")
			var pos = intersect.position
			var lookAtTarget = Vector3(pos.x, $Unit.position.y, pos.z)
			$Unit.look_at(lookAtTarget, Vector3.UP )
