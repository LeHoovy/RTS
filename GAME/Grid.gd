extends TileMap

var size = get_used_rect().size
var startY = get_used_rect().position.y
var startX = get_used_rect().position.x
var width = size.x
var height = size.y
#Finds the overall size of the map.

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

func getTileAt(position):
#	var tile : Vector2 = to_global(map_to_local(local_to_map(get_global_mouse_position() / scale)))
	var tile : Vector2i = local_to_map(position / scale)
	#Takes the mouse's position, divides it by the scale of the map
	#Then it snaps the coordinates to the coordinates of the cell, then it brings it back to global
#	print(tile)
	return tile

func findVector(position):
	return vectorLocation.has(vectorLocation.find_key(position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile1 = Vector2i()
	var tile2 = Vector2i()
	
	if Input.is_action_just_pressed("MB1"):
		
		var tile = getTileAt(get_global_mouse_position())
		if  findVector(tile) == true:
#			print(tile)
			#If left clicked, check for the cell type. If its pathable, continue.
			
			var rotate = randi_range(-3, 4) * 45
#			print("Rotated ", rotate, " degrees")
			#Generates the number to rotate the vector by
			
			var vector = vectorLocation.find_key(Vector2i(tile.x, tile.y))
			vector = get_node(vector)
			var vectorDir = vector.rotation_degrees
			vectorDir += rotate
			#Finds the vector, then rotates it
			
			if vectorDir >= 360:
				vectorDir -= 360
			elif vectorDir <= -360:
				vectorDir += 360
			round(vectorDir)
#			print(vectorDir)
			#Makes sure it doesn't rotate too far
			
			vector.rotation = deg_to_rad(vectorDir)
			
#			vector.locate()
#
#			var neighbor = get_neighbor_cell(tile, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
#			if findVector(neighbor) == true:
#				if get_cell_atlas_coords(0, Vector2i(neighbor)) == Vector2i(1, 0):
#					erase_cell(0, neighbor)
#				else:
#					set_cell(0, neighbor, 0, Vector2i(1, 0))
#				print(neighbor)
			#If the cell exists and is pathable, go ahead and toggle it
			
			var neighbors = get_surrounding_cells(tile)
			#get surrounding cells creates an Vector2i array, in the cell order, east, south, west, north
			for i in neighbors:
				if findVector(i) == true:
					print(i)
					
			print("| BREAK |")
			print("")
