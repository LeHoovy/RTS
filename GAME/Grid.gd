class_name Grid
extends Node2D

@export var width: int = 12
@export var height: int = 12
@export var cellSize: int = 128
#Sets the map to be width cells by height cells, with each cell being cellSize pixels by pixels large.
#Also allows you to change this in the node inspector rather than in the grid.

var grid: Dictionary = {}
#Stores what data a cell contains.
@export var show_debug: bool = false
#Allows you to see the grid by hitting a button in the inspector.
func generateGrid():
	for x in width:
		for y in height:
			grid[Vector2(x,y)] = null
			#Generates the grid.
			#How it functions: it repeats width times a process that repeats height times to generate a grid and its location.
			if show_debug:
				var rect = ReferenceRect.new()
				rect.position = gridToWorld(Vector2(x,y))
				rect.size = Vector2(cellSize, cellSize)
				rect.editor_only = false
				add_child(rect)
				var label = Label.new()
				label.position = gridToWorld(Vector2(x,y))
				label.text = str(Vector2(x,y))
				add_child(label)
				#Shows the grid.

func gridToWorld(_pos: Vector2) -> Vector2:
	return _pos * cellSize
#returns the world position

func worldToGrid(_pos: Vector2) -> Vector2:
	return floor(_pos / cellSize)
#returns the grid position



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
