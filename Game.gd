extends Node3D

var rayOrigin = Vector3()
var rayTarget = Vector3()

func _physics_process(delta):
	
	var mousePos = get_viewport().get_mouse_position()
#	print("Mouse Position: ", mousePos)
	
	rayOrigin = $Camera3D.project_ray_origin(mousePos)
#	print("rayOrigin: ", rayOrigin)
	rayTarget = rayOrigin + $Camera3D.project_ray_normal(mousePos) * 2000

	
	var spaceState = get_world_3d().direct_space_state
	var parameters = PhysicsRayQueryParameters3D.create(from:rayOrigin,to:rayTarget)
	
	var intersect = spaceState.intersect_ray(parameters)
	
	
