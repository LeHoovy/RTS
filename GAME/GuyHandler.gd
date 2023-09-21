class_name GuyHandler
extends Node2D

var teamtscn = preload("res://teamController.tscn")

var basic_unit = preload("res://GameObjects/Control/Guy.tscn")
var units : Array

var selected : Array
var selectable : Node = null

var current_team_id : int = randi_range(1, 2)
var current_team : Node
#var team_count : int = 2
@export var starting_team_count : int = 3
var teams : Array[Node]


func spawnTeam(current):
	if teams.size() < 16:
		var team = teamtscn.instantiate()
		team.name = str("team", "%0*d" % [2, current])
		team.team = current
		team.team_color = "%0*d" % [2, current]
		add_child(team)
		teams.append(team)


func teamLoss(defeated : Node):
#	team_count -= 1
	defeated.queue_free()
	teams.pop_back()


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(starting_team_count):
		spawnTeam(i)
	print(teams)
	print(current_team_id)
	current_team = teams[current_team_id]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("["):
		if current_team_id == teams.size():
			current_team_id -= 1
		teamLoss(get_node(str("team", "%0*d" % [2, teams.size()])))
		print(teams)
	if Input.is_action_just_pressed("]"):
		spawnTeam(teams.size() + 1)
#		team_count += 1
		print(teams)
	if Input.is_action_just_pressed("-") and current_team_id > 1:
		current_team_id -= 1
		current_team = teams[current_team_id]
		print(current_team)
	if Input.is_action_just_pressed("+") and current_team_id < teams.size() - 1:
		current_team_id += 1
		current_team = teams[current_team_id]
		print(current_team)
		print(current_team_id)
	if Input.is_action_just_pressed("MB2"):
		for unit in selected:
			unit.startStop(true)
			unit.target = get_local_mouse_position()
			print(unit.target, get_global_mouse_position())
	

	#detects if you click a unit


func _process(delta):
	if selectable != null and Input.is_action_just_pressed("MB1"):
		if Input.is_action_pressed("Shift"):
			if !selected.has(selectable) and selected.size() != 200:
				selected.append(selectable)
		else:
			selected.clear()
			selected.append(selectable)
		print(selected)
	if Input.is_action_just_pressed("Space"):# and get_parent().findVector(get_parent().getTileAt(get_global_mouse_position())):
		spawnGuy(1, get_parent().map_to_local(get_parent().getTileAt(get_global_mouse_position())))


func _input(event):
	pass


func spawnGuy(team, pos):
	var named : bool = false
	var guy : Node = basic_unit.instantiate()
	#Instantiate it and reset "named" to false
	guy.position = pos
	#set it to the target position
	guy.team_color = "%0*d" % [2, current_team_id]
	for unit in units.size():
		if !units.has(str("guy",team, "_", unit)):
			guy.name = str("guy", team, "_", unit)
			named = true
		#Checks for available names, and so it doesn't overwrite current guys
	if named == false:
		guy.name = str("guy", units.size())
		named = true
	#If no available name is found, i.e no units have been lost, add a new guy
#	guy.scale = Vector2(0.25, 0.25)
	units.append(guy.name)
	current_team.add_child(guy)
	#Finally, create the child
