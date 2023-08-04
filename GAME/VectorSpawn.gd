extends Node2D

var vectorArrow = load("res://Debug/Vector.tscn")
var arrowCount = 0
#var scaleSize
#var root = get_parent()
#Gets ready to spawn arrows

var vectorLocate = {}

func begun():
	vectorLocate = get_parent().vectorLocation
#	scaleSize = 0.125 * get_parent().scale
#	print(scaleSize)

func spawnVector(x, y, posx, posy):
	#Spawns the vector arrow
	var root = get_parent()
	var arrow = vectorArrow.instantiate()
	arrow.position = Vector2(x / root.scale.x, y / root.scale.y)
	#Prepares the vector arrow to spawn
	root.add_child(arrow)
	arrowCount += 1
	#Spawns the arrow and counts how many have been spawned.
	
	arrow.relPos = Vector2i(posx, posy)
	arrow.name = str("vector", arrowCount)
	arrow.root = root
	
	root.pathfind.connect(arrow.pathfind)
	
	vectorLocate[arrow] = Vector2i(posx, posy)
	#Stores the arrow in the dictionary "vectorLocate" to be used later

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
