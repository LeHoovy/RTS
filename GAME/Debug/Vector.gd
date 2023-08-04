extends Sprite2D


var visited : bool = false
var active : bool = true
var heat = 0
var root
var relPos = Vector2i()

var detail : String = "not checked"

var neighborVectors = []
var min : int
var averageMag : float

var quickRadian = PI / 4




func pathfind():
	if !root.neighboringVectors(relPos) or root.neighborTarget(relPos):
		rotation_degrees = root.findBestNeighbor(relPos).targetDir * 45
	else:
		findBestDir()
#		rotation_degrees = 0
	if frame == 1:
		if heat != 0:
			frame = 0
		else:
			rotation_degrees = 0
	elif heat == 0:
		frame = 1
		rotation_degrees = 0
		




func findBestDir():
	var smallestNodes = {}
	neighborVectors = root.readyVectorNeighbors(relPos)
	min = neighborVectors.min()
	
	for i in neighborVectors.size():
		if neighborVectors[i] == min:
			smallestNodes[i] = neighborVectors[i]
	
	if smallestNodes.size() > 1:
		if smallestNodes.has(7) and smallestNodes.has(0): 
			if smallestNodes.size() == 3:
				rotation = 0
			else:
				rotation = 7.5 * quickRadian
		elif smallestNodes.size() == 3:
			rotation = smallestNodes.keys()[1] * quickRadian
		elif smallestNodes.size() == 2:
			rotation = float(smallestNodes.keys()[1] - 0.5) * quickRadian
	else:
		rotation = smallestNodes.keys()[0] * quickRadian
	#	neighbors = root.readyVectorNeighbors(relPos)
#	min = neighbors.min()
#	var totalMin = 0
#	var allMin = {}
#
#	for vec in neighbors.size():
#		if neighbors[vec] == min:
#			totalMin += 1
#			allMin[neighbors[vec]] = vec
		
	
#	print(max)
#	var kernel = root.readyVectorNeighbors(root.getAllSurroundingCells(relPos))
#	for i in kernel.size():
#		kernel.append(1 / kernel[i] * 10)
#	for i in kernel.size() / 2:
#		kernel.pop_front()
##	print(kernel)
#	var kernel2 = float(0)
#	for i in kernel.size():
#		var no1 = kernel[i]
#		var no2 = kernel[i - 1]
#		kernel2 += no1 * no2
##	for i in kernel:
##		kernel2 += i
#	print(kernel2)
#	rotation = kernel2 
	




func f(input):
	return float(1 / input)





#func locate():
#	print(relPos)




func findHeat():
#	print(visited)
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
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if !visited:
#		rotation = 0
#	pass
