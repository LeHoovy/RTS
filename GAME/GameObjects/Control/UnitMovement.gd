extends CharacterBody2D

#@export var size : float = 75
var target : Vector2 = Vector2(0, 0)
var touchedVectors : Array = []
@onready var area2d : Node = get_node("DirDetect")
var vecRot : Array = []
var dir : float = 0
var speed : float = 0
var moving : bool = false

@export_category("Primary Unit Stats")
@export_range(1, 100, 0.1, "or_greater") var moveSpeed : float = 50

@export_category("Secondary Unit Stats")
#Ground units should have atleast 0.7 Acceleration
@export_range(0.1, 1, 0.05) var acceleration : float = 0.9


# Called when the node enters the scene tree for the first time.
func _ready():
	print(name)
#	if size < 0.5:
#		size = 0.5
#
#	scale.x = size / 100
#	scale.y = size / 100


func velocityCalc():
	if speed > moveSpeed:
		speed = moveSpeed
	elif speed < moveSpeed:
		speed += acceleration
	velocity = transform.x * speed
	if touchedVectors.size() == 1 and touchedVectors[0].get_parent():
		speed = 0


func startStop(toggle = null):
	if toggle is bool:
		moving = toggle
	else:
		moving != moving


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if moving:
		velocityCalc()
		move_and_slide()
	if Input.is_action_just_pressed("MB2"):
		startStop(true)
		target = get_local_mouse_position()
		print(target, get_global_mouse_position())
	


func updateDir(area):
	if moving == true:
		vecRot.clear()
		dir = 0
		touchedVectors = area2d.get_overlapping_areas()
		if touchedVectors.size() < 1:
			startStop()
		else:
			for i in touchedVectors:
				if i.get_parent() is Sprite2D and !vecRot.has(i.get_parent() and i.get_parent().heat > 0):
					vecRot.append(i.get_parent().rotation)
				elif i.get_parent().heat < 1:
					startStop()
			for i in vecRot:
		#		i.activeTog()
				dir += i
			if vecRot.max() - vecRot.min() > 6 * (PI / 4):
				dir += 8 * (PI / 4)
			dir = dir / vecRot.size()
			rotation = dir
#	print(vecRot)
