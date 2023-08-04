extends TileMap

var size = get_used_rect().size
var startY = get_used_rect().position.y
var startX = get_used_rect().position.x
var width = size.x
var height = size.y
#Finds the overall size of the map.

#var target = Vector2i()

@onready var vectorLocation = {}
#Prepares vectorLocation as the vectorLocate dictionary found in the ArrowSpawner node

var open = [] #or {}
#var queue = []
#var allNeighbors = []
#Prepares arrays to store stuff for pathfinding

signal pathfind




func neighboringVectors(tile):
	var neighboringTiles = getAllSurroundingCells(tile)
	var neighboringVectors = 0
	for i in neighboringTiles:
		if findVector(i):
			neighboringVectors += 1
	if neighboringVectors == 8:
		return true
	else:
		return false




# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("ArrowSpawner").begun()
	for x in width:
		for y in height:

#			var pos = to_global(map_to_local(Vector2(x + startX, y + startY)))
#			print("Exact location: ", pos, " Tilemap Coordinates: (", x, ",", y, ")")
			#Finds the position in the world of each tile.

			var cell = get_cell_atlas_coords(0, Vector2(x + startX, y + startY))
#			if cell == Vector2i(0, 0) or cell == Vector2i(1, 0):
			if cell == Vector2i(1, 0):
			#Makes sure the cell can be pathed on, then activates the rest of the script.

#				print(pos, ", (", x, ",", y, ")")
#				print(cell)

				var pos = to_global(map_to_local(Vector2(x + startX, y + startY)))
				#Finds the position in the world of each tile.
	
				get_node("ArrowSpawner").spawnVector(pos.x, pos.y, x + startX, y + startY)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile = int()
#	var tile1 = Vector2i()
#	var tile2 = Vector2i()
	var best = []
	
	if Input.is_action_just_pressed("MB2"):
		tile = getTileAt(get_global_mouse_position())
		
		if findVector(tile) == true:
#			print(tile)
			#If left clicked, check for the cell type. If its pathable, continue.
			
			readyPathfind(tile)
			
	if Input.is_action_just_pressed("MB1"):
		tile = getTileAt(get_global_mouse_position())
		tile = getVector(tile)
		tile.findHeat()
#		pathfind.emit()
		#Prints the heat of any left-clicked vector




func getTileAt(pos):
	var tile : Vector2i = local_to_map(pos / scale)
	#Takes the mouse's position, divides it by the scale of the map
	#Then it snaps the coordinates to the coordinates of the cell, then it brings it back to global
	return tile




func findVector(pos):
	return vectorLocation.has(vectorLocation.find_key(pos))




func getVector(pos):
	var arrow = vectorLocation.find_key(pos)
	return arrow




func readyVectorNeighbors(pos):
	var array = getAllSurroundingCells(pos)
	var list = []
	for i in array:
		list.append(getVector(i).heat)
	return list




func neighborTarget(node):
	var list = getAllSurroundingCells(node)
	for i in list:
		if getVector(i).heat == 0:
			return true
			break
	return false




func getAllSurroundingCells(cell):
	var allNeighbors = [
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_RIGHT_SIDE), #0
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER), #45
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), #90
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER), #135
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_LEFT_SIDE), #180
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER), #225
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_SIDE), #270
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)]#315
	return allNeighbors




func clearHeatMap():
	for i in vectorLocation:
		i.visited = false




#VERY IMPORTANT
func genHeatMap(target):
	open.append(target)
	
	while open.size() > 0:
#		print(a)
		var current = getVector(open[0])
		var neighbors = get_surrounding_cells(open[0])
#		var neighbors = get_surrounding_cells(open[0])
		for b in neighbors:
			if findVector(b) == true:
				var selected = getVector(b)
				if selected.visited == true:
					if selected.heat > current.heat + 1: 
					#dist.n(b(a?)) > dist.c(a(b?)) + abs(dist.c.position - dist.n.position, or just 2, maybe 1)
						selected.heat = current.heat + 1
				else:
					selected.heat = current.heat + 1
					selected.visited = true
					if open.has(b) == false:
						open.append(b)


		open.pop_front()





func readyPathfind(target):
	var current = Vector2i()

	clearHeatMap()

	getVector(target).visited = true
	getVector(target).heat = 0
	open = []
	genHeatMap(target)
	
#	await finished
	
#	print("finished")
	
	pathfind.emit()
#	for i in vectorLocation:
#		current = i
##		current = get_node(current)
##		print(current.visited)
##		findBestNeighbor(current)
#		var bestNeighbor = findBestNeighbor(current.relPos)
#		var targetDir = bestNeighbor.targetDir * 45
#		bestNeighbor = bestNeighbor.bestFit
##		#finds the neighboring tile with the lowest heat.
#
#		if current.frame == 1:
#			current.target()
#
#		current.rotation = deg_to_rad(targetDir)
#		#converts the pending vector rotation to degrees, then actually rotates it
#
#		getVector(target).frame = 1
		
#	vector.heat = abs(target.x - vector.position.x) + abs(target.y - vector.position.y)




func findBestNeighbor(cell):
	var current = Vector2()
	var best = 0
	var heat = getVector(cell).heat
#	heat = get_node(heat)
#	heat = heat.heat
	var min1 = heat - 1
	var min2 = heat - 2
	var angle = 0
	var neighborArray = getAllSurroundingCells(cell)

	if getVector(cell).heat != 0:
		for i in neighborArray.size():
	#		print(i)
			if findVector(neighborArray[i]) == true:
				current = getVector(neighborArray[i])
				if current.heat <= min2:
					best = neighborArray[i]
					angle = i
	#				print(angle)
					break
				elif current.heat <= min1:
					best = neighborArray[i]
					angle = i
	#				print(angle)

#Checks each neighboring node in the array if they have a vector, and if they do, checks their heat.
#It then stores whichever has the least heat in "best."
#	print(min2)
	return {"bestFit":best, "targetDir":angle}




#func genHeatMap(tile, counter):
##	tile = findVector(tile)
##	if tile == true:
#	tile = getVector(tile)
##	counter += 1
#	var surroundCells = get_surrounding_cells(Vector2i(tile.relPos.x, tile.relPos.y))
#	for i in surroundCells:
#		var selected = findVector(i)
#		if selected == true:
##			genHeatMap(i, counter)
#			selected = getVector(i)
#			if selected.visited == false:
#				selected.visited = true
#				selected.heat = counter
#				if queue.has(selected) == false:
#					queue.append(Vector2i(selected.relPos.x, selected.relPos.y))
#			else:
#				if selected.heat > counter:
#					selected.heat = counter
##				selected.visited = true
##				selected.heat = abs(tile.relPos.x - goal.x) + abs(tile.relPos.y - goal.y)
##				open.append(Vector2i(selected.relPos.x, selected.relPos.y))
##	if open.size() == 0:
##		genHeatMap(open[0], counter, goal)
#	open.pop_front()
#	if open.size() == 0:
#		if queue.size() > 0:
#			print("continue")
#		open = queue
#		queue.clear()
#		counter += 1
#	elif open.size() > 0:
#		genHeatMap(open[0], counter)
#	#do manhattan, each corner = 2, x+y
