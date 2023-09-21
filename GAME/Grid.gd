class_name PathingHandler
extends TileMap

var size : Vector2i = get_used_rect().size
var startY : int = get_used_rect().position.y
var startX : int = get_used_rect().position.x
var width : float = size.x
var height : float = size.y
#Finds the overall size of the map.

#var target = Vector2i()

@onready var vectorLocation : Dictionary
@onready var guysHandle : Node = get_node("GuyHandler")
#Prepares vectorLocation as the vectorLocate dictionary found in the ArrowSpawner node

var prevTarget : Vector2i = Vector2i(-1, -1)
var target : Vector2
var open : Array
#Prepares arrays to store stuff for pathfinding

signal pathfind



func get_shortest_path(start : Array, end = Vector2()):
	pass
	


func neighboringVectors(tile):
	var neighboringTiles : Array = getAllSurroundingCells(tile)
	var neighboringVectors : int = 0
	for i in neighboringTiles:
		if findVector(i):
			neighboringVectors += 1
	if neighboringVectors == 8:
		return true
	else:
		return false


# Called when the node enters the scene tree for the first time.
func _ready():
	for x in width:
		for y in height:

#			var pos = to_global(map_to_local(Vector2(x + startX, y + startY)))
#			print("Exact location: ", pos, " Tilemap Coordinates: (", x, ",", y, ")")
			#Finds the position in the world of each tile.

#			var cell : Vector2i = get_cell_atlas_coords(0, Vector2(x + startX, y + startY))
#			if cell == Vector2i(0, 0) or cell == Vector2i(1, 0):
			if get_cell_atlas_coords(0, Vector2(x + startX, y + startY)) == Vector2i(1, 0):
			#Makes sure the cell can be pathed on, then activates the rest of the script.

#				print(pos, ", (", x, ",", y, ")")
#				print(cell)

				var pos : Vector2 = to_global(map_to_local(Vector2(x + startX, y + startY)))
				#Finds the position in the world of each tile.
	
				spawnVector(pos.x, pos.y, x + startX, y + startY)



var vectorArrow = preload("res://Debug/Scenes/Vector.tscn")
var arrowCount = 0
func spawnVector(x, y, posx, posy):
	#Spawns the vector arrow
#	var root = get_parent()
	var arrow = vectorArrow.instantiate()
	arrow.position = Vector2(x / scale.x, y / scale.y)
	#Prepares the vector arrow to spawn
	add_child(arrow)
	arrowCount += 1
	#Spawns the arrow and counts how many have been spawned.
	
	arrow.relPos = Vector2i(posx, posy)
	arrow.name = str("vector", arrowCount)
	arrow.root = self
	
	pathfind.connect(arrow.pathfind)
	
	vectorLocation[arrow] = Vector2i(posx, posy)
	#Stores the arrow in the dictionary "vectorLocate" to be used later


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile : Vector2i
#	var tile1 = Vector2i()
#	var tile2 = Vector2i()
	var best : Array
	
	if Input.is_action_just_pressed("MB2"):
		tile = getTileAt(get_global_mouse_position())
		target = get_global_mouse_position()
		if findVector(tile) == true:
#			print(tile)
			#If left clicked, check for the cell type. If its pathable, continue.
			
			readyPathfind(tile)
			
		
	


func getTileAt(pos):
	var tile : Vector2i = local_to_map(pos / scale)
	#Takes the mouse's position, divides it by the scale of the map
	#Then it snaps the coordinates to the coordinates of the cell, then it brings it back to global
	return tile


func findVector(pos):
	return vectorLocation.has(vectorLocation.find_key(pos))


func getVector(pos):
	var arrow : Node = vectorLocation.find_key(pos)
	return arrow


func readyVectorNeighbors(pos):
	var array : Array = getAllSurroundingCells(pos)
	var list : Array
	for i in array:
		list.append(getVector(i).heat)
	return list


func neighborTarget(node):
	var list : Array = getAllSurroundingCells(node)
	for i in list:
		if getVector(i).heat == 0:
			return true
			break
	return false


func getAllSurroundingCells(cell):
	var allNeighbors : Array = [
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
		i.activeTog()


#VERY IMPORTANT
func genHeatMap(target):
	open.append(target)
	
	while open.size() > 0:
#		print(a)
		var current : Node = getVector(open[0])
		var neighbors : Array = getAllSurroundingCells(open[0])
#		var neighbors = get_surrounding_cells(open[0])
		for b in neighbors:
			if findVector(b) == true:
				var selected : Node = getVector(b)
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
	if prevTarget != Vector2i(-1, -1):
		set_cell(0, prevTarget, 0, Vector2i(1, 0))
	set_cell(0, target, 0, Vector2i(1, 1))
	prevTarget = target
	
	var current : Vector2i

	clearHeatMap()

	getVector(target).visited = true
	getVector(target).heat = 0
	open = []
	genHeatMap(target)
	
#	await finished
	
#	print("finished")
	
	pathfind.emit()


func findBestNeighbor(cell):
	var current : Node
	var best : Vector2i
	var heat : int = getVector(cell).heat
#	heat = get_node(heat)
#	heat = heat.heat
	var min1 : int = heat - 1
	var min2 : int = heat - 2
	var angle : int = 0
	var neighborArray : Array = getAllSurroundingCells(cell)

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
