extends TileMap

var size = get_used_rect().size
var startY = get_used_rect().position.y
var startX = get_used_rect().position.x
var width = size.x
var height = size.y
#Finds the overall size of the map.

#var target = Vector2i()

@onready var vectorLocation = get_node(^"ArrowSpawner").vectorLocate
#Prepares vectorLocation as the vectorLocate dictionary found in the ArrowSpawner node

# Called when the node enters the scene tree for the first time.
func _ready():
#	print("The map is ",width," tiles wide and ", height, " tiles tall, starting at the coordinates (",startY, ", ", startX, ").")
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
				
				
#	get_node("ArrowSpawner").spawnVector(x + startX, y + startY)
#	print($ArrowSpawner.arrowCount, " arrows printed")
#	print($ArrowSpawner.vectorLocate)
	
#	var x = get_node("ArrowSpawner").vectorLocate.find_key(Vector2(315, 175))
#	print (x)


func getTileAt(pos):
#	var tile : Vector2 = to_global(map_to_local(local_to_map(get_global_mouse_position() / scale)))
	var tile : Vector2i = local_to_map(pos / scale)
	#Takes the mouse's position, divides it by the scale of the map
	#Then it snaps the coordinates to the coordinates of the cell, then it brings it back to global
#	print(tile)
	return tile


func findVector(pos):
	return vectorLocation.has(vectorLocation.find_key(pos))


func clearHeatMap(vector):
	vector.heat = 0


func findBestNeighbor(cell):
	var best = 0
	var heat = vectorLocation.find_key(cell)
	heat = get_node(heat)
	heat = heat.heat
	var min1 = heat - 1
	var min2 = heat - 2
	var angle = 0
#	var R = 
#	var BR = 
#	var B = 
#	var BL = 
#	var L = 
#	var TL = 
#	var T = 
#	var TR = 
	var neighborArray = [
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_RIGHT_SIDE), #0
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER), #45
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE), #90
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER), #135
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_LEFT_SIDE), #180
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER), #225
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_SIDE), #270
		get_neighbor_cell(cell, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)]#315
	#Finds each neighboring node and stores them in an array.
	
#	get_node(array[0]).locate()
	for i in neighborArray.size():
		if findVector(neighborArray[i]) == true and get_node(vectorLocation.find_key(cell)).heat != 0:
			if get_node(vectorLocation.find_key(neighborArray[i])).heat == min2:
				best = neighborArray[i]
				angle = i
				print(angle)
				break
			elif get_node(vectorLocation.find_key(neighborArray[i])).heat == min1:
				best = neighborArray[i]
				angle = i
				print(angle)

#Checks each neighboring node in the array if they have a vector, and if they do, checks their heat.
#It then stores whichever has the least heat in "best."
#	print(min2)
	return {"bestFit":best, "targetDir":angle}


func readyPathfind(target):
	var current = Vector2i()
	var locate = vectorLocation.keys()
#	print(locate)
	for i in locate:
		current = i
		current = get_node(current)
		current.heat = abs(target.x - current.relPos.x) + abs(target.y - current.relPos.y)
#		print(current.heat)
	#generates the heatmap, each tile has a heat of 1 for every tile to either side and up or down
	
		if current.relPos == target:
			current.heat = 0
	#Makes sure that the target has a heat of 0 as to make sure the game doesn't break.
	
	for i in locate:
		current = i
		current = get_node(current)
#		findBestNeighbor(current)
		var bestNeighbor = findBestNeighbor(current.relPos)
		var targetDir = bestNeighbor.targetDir * 45
		bestNeighbor = bestNeighbor.bestFit
#		#finds the neighboring tile with the lowest heat.
		
		if current.frame == 1:
			current.toggleVisibility()
		
		current.rotation = deg_to_rad(targetDir)
		#converts the pending vector rotation to degrees, then actually rotates it
		
		get_node(vectorLocation.find_key(target)).frame = 1
		
#	vector.heat = abs(target.x - vector.position.x) + abs(target.y - vector.position.y)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	var tile1 = Vector2i()
#	var tile2 = Vector2i()
	var best = []
	
	if Input.is_action_just_pressed("MB2"):
		
		var tile = getTileAt(get_global_mouse_position())

		
		if  findVector(tile) == true:
#			print(tile)
			#If left clicked, check for the cell type. If its pathable, continue.
			
#			get_node(vectorLocation.find_key(tile)).toggleVisibility()
			
#			var temp = get_node(vectorLocation.find_key(tile)).toggleVisibility()
#			temp.toggleVisibility()
			
			var rotateDist = randi_range(-3, 4) * 45
#			print("Rotated ", rotate, " degrees")
			#Generates the number to rotate the vector by
			
#			var vector = vectorLocation.find_key(Vector2i(tile.x, tile.y))
#			vector = get_node(vector)
			#Finds the vector, then rotates it
			
			readyPathfind(tile)
			
			
			

