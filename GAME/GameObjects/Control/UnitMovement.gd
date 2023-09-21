extends CharacterBody2D

#@export var size : float = 75
var target : Vector2 = Vector2(0, 0)
var touchedVectors : Array = []
@onready var area2d : Node = get_node("DirDetect")
var vec_rot : Array = []
var dir : float = 0
var speed : float = 0
var moving : bool = false

var possible_atk_targets : Dictionary

var input = false

var team_color : String
@onready var color = load(str("res://GameObjects/Textures/Guy/", team_color, ".png"))

var state : int
#0 is stopped, 1 is moving, 2 is patrolling, 3 is holding position, and 4 is attacking

@onready var handler = get_parent().get_parent()

@export_category("Primary Unit Stats")
@export_range(1, 1000, 1, "or_greater") var max_health : int = 50
@onready var health = max_health
@export_range(1, 100, 0.1, "or_greater") var move_speed : float = 50

@export_category("Attack stats")
@export_range(1, 200, 0, "or_greater") var attack_power : int = 1
@export_range(1, 50, 0, "or_greater") var attack_count : int = 1
@export_range(0, 5, 0.01, "or_greater") var attack_speed : float = 1
@export_range(1.5, 100, 1, "or_greater") var attack_range : float = 5

@export_category("Hidden Attack Stats")
@export_range(0, 2, 0.01, "or_greater") var attackPoint : float = 0.01

@export_category("Hidden Extra Unit Stats")
#Ground units should have atleast 0.7 Acceleration
@export_range(0.1, 1, 0.05) var acceleration : float = 0.9
@export_range(0.25, 10) var size : float = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	var pathfind_colliders : Array[Node] = [$Collider, $DirDetect/CollisionShape2D]
	var targeting_system : Array[Node] = [$Range/CollisionShape2D]
	for i in pathfind_colliders:
		i.shape.radius = size
	$Color.scale = Vector2(size * 2, size * 2)
	$Selector.scale = Vector2(size * 0.02, size * 0.02)
	targeting_system[0].shape.radius = attack_range
	print(name)
	print(color)
	$Color.set_texture(color)
#	if size < 0.5:
#		size = 0.5
#
#	scale.x = size / 100
#	scale.y = size / 100


func attack(target : Node):
	
	for i in attack_count:
		attack(null)
		wait(attackPoint)
	wait(attack_speed)


func velocityCalc():
	if speed > move_speed:
		speed = move_speed
	elif speed < move_speed:
		speed += acceleration
	velocity = transform.x * speed
	if touchedVectors.size() == 1 and touchedVectors[0].get_parent():
		speed = 0


func startStop(toggle = null):
	if toggle is bool:
		moving = toggle
	else:
		moving != moving


func _physics_process(delta):
	if moving and state == 0:
		state = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if handler.selected.has(self):
		$Selector.visible = true
	else:
		$Selector.visible = false
	if moving:
		velocityCalc()
		move_and_slide()
#	if Input.is_action_just_pressed("MB2"):
#		startStop(true)
#		target = get_local_mouse_position()
#		print(target, get_global_mouse_position())
	


func updateDir(area):
	
	if moving == true:
		vec_rot.clear()
		dir = 0
		touchedVectors = area2d.get_overlapping_areas()
		if touchedVectors.size() < 1:
			startStop()
		else:
			for i in touchedVectors:
				if i.get_parent() is Sprite2D and !vec_rot.has(i.get_parent()) and i.get_parent().heat > 0:
					vec_rot.append(i.get_parent().rotation)
				elif i.get_parent().heat < 1:
					startStop(false)
			for i in vec_rot:
		#		i.activeTog()
				dir += i
			if vec_rot.max() - vec_rot.min() > 6 * (PI / 4):
				dir += 8 * (PI / 4)
			dir = dir / vec_rot.size()
			rotation = dir
#	print(vecRot)


func mouse_entered():
	if handler.selectable == null:
		handler.selectable = self
	elif handler.selectable.position.y > position.y:
		handler.selectable = self


func mouse_exited():
	if handler.selectable == self:
		handler.selectable = null


func wait(time, interruptable : bool = true):
	var timer : float
	var deltaC : float
	
	while timer < time:
		deltaC = get_process_delta_time()
		timer += deltaC
		if interruptable and handler.selected.has(self) and Input.is_action_just_pressed("MB2"):
			break


func range_entered(area):
	if area.get_parent().get_parent() != get_parent():
		possible_atk_targets[area.get_parent()] = area


func range_exited(area):
	possible_atk_targets.erase(possible_atk_targets.find_key(area))

