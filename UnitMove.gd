extends CharacterBody3D

var speed = 5


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




func _process(delta):
	
	velocity = Vector3()
	
	if Input.is_action_pressed("ui_right"):
		velocity.x -= 5 * delta
	if Input.is_action_pressed("ui_left"):
		velocity.x += 5 * delta
	if Input.is_action_pressed("ui_up"):
		velocity.z += 5 * delta
	if Input.is_action_pressed("ui_down"):
		velocity.z -= 5 * delta
		
	velocity = velocity.normalized() * speed
	
	set_velocity(velocity)
	move_and_slide()
#	if Input.is_action_just_pressed("ui_right"):
#		velocity.x += 1
#	if Input.is_action_just_pressed("ui_left"):
#		velocity.x += 1
#	if Input.is_action_just_pressed("ui_up"):
#		velocity.x += 1
#	if Input.is_action_just_pressed("ui_down"):
#		velocity.x += 1

		
