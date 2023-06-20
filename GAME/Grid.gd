extends TileMap

var size = get_used_rect().size
var startY = get_used_rect().position.y
var startX = get_used_rect().position.x
var width = size.x
var height = size.y
#Finds the overall size of the map.



# Called when the node enters the scene tree for the first time.
func _ready():
	print("The map is ",width," tiles wide and ", height, " tiles tall, starting at the coordinates (",startY, ", ", startX, ").")
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
	
				get_node("ArrowSpawner").spawnVector(pos.x, pos.y)
				
				
#	get_node("ArrowSpawner").spawnVector(x + startX, y + startY)
	print($ArrowSpawner.arrowCount)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
