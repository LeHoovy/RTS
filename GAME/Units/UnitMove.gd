extends CharacterBody3D           

var rayOrigin = Vector3()
var rayTarget = Vector3()

var speed = 5.0

@onready var navAgent = $NavigationAgent3D

var path = []


func _physics_process(delta):
    if navAgent.is_navigation_finished():
        return

    var current_location = global_transform.origin
    var next_location = navAgent.get_next_path_position()
    var newVelocity: Vector3 = (next_location - current_location).normalized() * speed

    set_velocity(newVelocity)
    move_and_slide()


func updateTargetLocation(targetLocation):
    navAgent.set_target_location(targetLocation)


func _process(delta):

    var mousePos = get_viewport().get_mouse_position()#
        #print("Mouse Position: ", mousePos)

    rayOrigin = get_parent().get_node("Cam").get_node("Camera3D").project_ray_origin(mousePos)
    #print("rayOrigin: ", rayOrigin)
    rayTarget = rayOrigin + get_parent().get_node("Cam").get_node("Camera3D").project_ray_normal(mousePos) * 2000
    #Locate mouse position and set position for a ray to the world

    var spaceState = get_world_3d().direct_space_state
    var parameters = PhysicsRayQueryParameters3D.create(rayOrigin, rayTarget)
    var intersect = spaceState.intersect_ray(parameters)
    #Locate x,z position for intercept with terrain

    if Input.is_action_just_pressed("MB2"):
        if not intersect.is_empty():
            #print("NOT EMPTY!")
            var pos = intersect.position
            var lookAtTarget = Vector3(pos.x, position.y, pos.z)
            look_at(lookAtTarget, Vector3.UP )

            navAgent.set_target_position(pos)
            #Point at location when mouse button 2 pressed
#
#			navAgent.set_target_position(lookAtTarget)
#			var current_location = global_transform.origin
#			var next_location = navAgent.get_next_path_position()
#			var newVelocity =  (next_location - current_location).normalized() * speed
#
#			velocity = newVelocity
#			while get_parent().global_transform.origin != next_location:
#				print("MOVING")
#
#				move_and_slide()
#
#
#
