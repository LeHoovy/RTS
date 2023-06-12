extends CharacterBody3D
#
#var speed = 5
#var friction = 0.1
#
#func _process(delta):
#
#	if Input.is_action_pressed("ui_left"):
#		velocity.x += 1
#	if Input.is_action_pressed("ui_right"):
#		velocity.x -= 1
#
#	if Input.is_action_pressed("ui_down"):
#		velocity.z -= 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.z += 1
#
#	if Input.is_action_pressed("Lift"):
#		velocity.y += 1
#	if Input.is_action_pressed("Lower"):
#		velocity.y -= 1
#
#	velocity = velocity.normalized() * speed 
#
#	move_and_slide()
#
#	velocity = velocity.lerp(Vector3.ZERO, friction)
#	move_and_slide()
#
##	print(position)

@export var speed = 60
@export var friction = 0.2
@export var acceleration = 0.08

func get_input():
	var input = Vector3()
	input = Vector3(Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"), Input.get_action_strength("Lift") - Input.get_action_strength("Lower"), Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down"))
	#Detect inputs and slot them to directionals
	if input.length() > 1:
		input = input.normalized()
	return input


func _physics_process(delta):
	var input = get_input()
	if input.length() > 0:
		velocity = velocity.lerp(input * speed, acceleration)
		#If there is an input, accelerate to maximum speed.
	else:
		velocity = velocity.lerp(Vector3.ZERO, friction)
		#If there isn't, slow down.
	move_and_slide()
