extends Node2D

var vectorArrow = load("res://Debug/Vector.tscn")
var arrowCount = 0
#var root = get_parent()
#Gets ready to spawn arrows

var vectorLocate = {}

func spawnVector(x, y, posx, posy):
	#Spawns the vector arrow
	var root = get_parent()
	var arrow = vectorArrow.instantiate()
	arrow.position = Vector2(x / root.scale.x, y / root.scale.y)
	arrow.scale = Vector2(root.scale.x * 0.025, root.scale.y * 0.025)
	#Prepares the vector arrow to spawn
	
#	arrow.name = str("vector", Vector2(x, y))
	
	root.add_child(arrow)
	arrowCount += 1
	#Spawns the arrow and counts how many have been spawned.
	
	arrow.relPos = Vector2i(posx, posy)
	arrow.name = str("vector", arrowCount)
	vectorLocate[arrow.name] = Vector2i(posx, posy)
	#Stores the arrow in the dictionary "vectorLocate" to be used later

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
