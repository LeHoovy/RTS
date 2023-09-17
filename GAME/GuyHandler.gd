class_name GuyHandler
extends Node2D


var basicUnit = preload("res://GameObjects/Control/Guy.tscn")
var units : Array

var selected : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("MB2"):
		for unit in selected:
			$unit.startStop(true)
			$unit.target = get_local_mouse_position()
			print($unit.target, get_global_mouse_position())
	

	#detects if you click a unit


func _process(delta):
	if Input.is_action_just_pressed("MB1") and get_global_mouse_position():
		if Input.is_action_pressed("Shift"):
			if selected.size() != 200:
#				selected.append()
				pass
		else:
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
