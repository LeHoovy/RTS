extends Node2D


var basicUnit = load("res://Guy.tscn")
var units = []


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func spawnGuy(team, pos):
	var named : bool = false
	var guy : Node = basicUnit.instantiate()
	#Instantiate it and reset "named" to false
	guy.position = pos
	#set it to the target position
	for i in units.size():
		if !units.has(str("guy",team, "_", i)):
			guy.name = str("guy", team, "_", i)
			named = true
		#Checks for available names, and so it doesn't overwrite current guys
	if named == false:
		guy.name = str("guy", team, "_", units.size())
		named = true
	#If no available name is found, i.e no units have been lost, add a new guy
#	guy.scale = Vector2(0.25, 0.25)
	units.append(guy.name)
	add_child(guy)
	#Finally, create the child
