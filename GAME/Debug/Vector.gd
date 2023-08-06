extends Sprite2D


@export var debug : bool = true

var visited : bool = false
var active : bool = false
var heat = 0
var root
var relPos = Vector2i()
#Make sure its not visited on spawn, nor active, the heat is 0, and ready root and relPos

var detail : String = "not checked"

var neighborVectors = []

var quickRadian = PI / 4
#quickRadian = 1/8 of a circle. Multiply any rotation vector by this to snap it to the right rotation.



func pathfind():
	if !root.neighboringVectors(relPos) or root.neighborTarget(relPos):
		rotation_degrees = root.findBestNeighbor(relPos).targetDir * 45
	#If its a neighbor of the target, or of a wall, just have it point to the lowest heat neighbor
	else:
		findBestDir()
	#Otherwise, calculate the best direction to rotate.
	changeFrame()





func findBestDir():
	var smallestNodes = {}
	neighborVectors = root.readyVectorNeighbors(relPos)
	#prepares smallest nodes dict, and gets the neighboring vectors magnitude (heat)

	for i in neighborVectors.size():
		if neighborVectors[i] == neighborVectors.min():
			smallestNodes[i] = neighborVectors[i]
	#Counts the amount of neighboring vectors with the same magnitude, if its the smallest magnitude
	
	if smallestNodes.size() > 1:
		if smallestNodes.has(7) and smallestNodes.has(0): 
			if smallestNodes.size() == 3:
				rotation = 0
	#If theres more than 1 "smallest" vector, and contains a vector to the 7 and 0 positions
	#And there are 3 vectors with "smallest", rotate directly to the right
			else:
				rotation = 7.5 * quickRadian
		#If theres only 7 and 0, rotate to 7.5 * pi / 4
		elif smallestNodes.size() == 3:
			rotation = smallestNodes.keys()[1] * quickRadian
		#If theres 3 vectors, but no 7 and 0, rotate to the middle * pi / 4
		elif smallestNodes.size() == 2:
			rotation = float(smallestNodes.keys()[1] - 0.5) * quickRadian
		#If theres 2 vectors, and no 7 and 0, rotate to inbetween the vectors * pi / 4
	else:
		rotation = smallestNodes.keys()[0] * quickRadian
	#Finally, if theres only one smallest vector, rotate to it * pi / 4
	




func changeFrame():
	if debug == true and (active == true or visited == true):
		if heat == 0:
			frame = 0
			look_at(root.target)
		else:
			frame = 0
	else:
		frame = 2
	#If its been visited and debug is active, it can show, if not, it won't be visible


func activeTog():
	active = !active
	changeFrame()


#func locate():
#	print(relPos)




func findHeat():
	print(rotation)
	print(relPos)
	print(heat)




#func target():
#	if frame == 0:
#		rotation_degrees = 0
#		frame = 1
#	else:
#		frame = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	changeFrame()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	changeFrame()
#	pass
