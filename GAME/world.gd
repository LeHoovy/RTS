extends Node3D

var timer = 0
var producing = 0
var queue = 0


@export var unit: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#Sets the variables
#	if Input.is_action_just_pressed("11"):
#		producing = 1
#	#If command card column 1 row 1 (Default: Q) is pressed, set producing to 1.
#	if producing == 1:
#		if timer <= 10:
#			timer += 1 * delta
#	#Changes timer by 1 multiplied by delta until its larger than or equal to 10.
#		else:
#			producing = 0
#	#If timer is larger or equal to 10, turn off producing.
#	else :
#		timer = 0
	#Reset the timer if no longer producing.
#	print(timer)
	pass
	
	if Input.is_action_just_pressed("11"):
		queue += 1
		#Increase queue by 1 if more are to be spawned.

		if queue > 5:
			queue = 5
		print(queue)
		#If queue becomes longer than 5, set it back to 5.

	if queue > 1:
		$SpawnTimer.one_shot = false
	else:
		$SpawnTimer.one_shot = true
	#If more than one unit is queued to spawn, then restart when it finishes.


	if queue > 0 and $SpawnTimer.is_stopped():
		$SpawnTimer.start()
	#Starts the spawn timer if a unit is queued.
	
	

func _on_spawn_timer_timeout():
	queue -= 1
	print("Would've spawned!")
	pass # Replace with function body.
