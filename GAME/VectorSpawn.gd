extends Node2D

var vectorArrow = load("res://Debug/Vector.tscn")
var arrowCount = 0
#Gets ready to spawn arrows


func spawnVector(x, y):
	#Spawns the vector arrow
	
	var arrow = vectorArrow.instantiate()
	var root = get_parent()
	arrow.position = Vector2(x / root.scale.x, y / root.scale.y)
	arrow.scale = Vector2(0.1, 0.1)
	#Prepares the vector arrow to spawn
	
	root.add_child(arrow)
#	arrow.position = Vector2(x, y)
	arrowCount += 1
	#Spawns the arrow and increases its count.
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
