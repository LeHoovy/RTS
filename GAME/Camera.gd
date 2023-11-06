extends Node3D
class_name Camera


@export_category("Sensitivity")
@export_range(0.1, 20) var edge_scroll_sens: float = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func is_mouse_on_edge(percentage: float) -> Vector2i:
	var output: Vector2i = Vector2i(0, 0)
	if mouse_pos.x <= (percentage / 100) * screen_size.x:
		output.x = -1
	elif mouse_pos.x >= (screen_size.x * (percentage / 100) + screen_size.x - (((percentage / 100) * screen_size.x) * 2) - 1):
		output.x = 1
	if mouse_pos.y <= (percentage / 100) * screen_size.y:
		output.y = -1
	elif mouse_pos.y >= (screen_size.y * (percentage / 100) + screen_size.y - (((percentage / 100) * screen_size.y) * 2) - 1):
		output.y = 1
	#print((percentage / 100) * screen_size.x)
	#print(screen_size.x * (percentage / 100) + screen_size.x - (((percentage / 100) * screen_size.x) * 2))
	#print(mouse_pos, screen_size)
	#print(mouse_pos.y <= (percentage / 100) * screen_size.y)
	return output


var friction: float = 0.9
var move: Vector2i
func process_move(delta) -> void:
	mouse_pos = get_viewport().get_mouse_position()
	screen_size = get_viewport().get_visible_rect().size
	
	move = is_mouse_on_edge(1)
	cam_move_speed += Vector2(move) * delta #* (0.9 * edge_scroll_sens)
	#cam_move_speed *= friction
	if cam_move_speed.x > edge_scroll_sens / 5:
		cam_move_speed.x = edge_scroll_sens / 5
	elif cam_move_speed.x < -(edge_scroll_sens / 5):
		cam_move_speed.x = -edge_scroll_sens / 5
	
	if cam_move_speed.y > edge_scroll_sens:
		cam_move_speed.y = edge_scroll_sens
	elif cam_move_speed.y < -edge_scroll_sens:
		cam_move_speed.y = edge_scroll_sens
	
	if move.x == 0:
		cam_move_speed.x = 0
	if move.y == 0:
		cam_move_speed.y = 0
	
	#print(cam_move_speed)
	position.x += cam_move_speed.x
	position.z += cam_move_speed.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
var mouse_pos: Vector2
var screen_size: Vector2
var cam_move_speed: Vector2
func _process(delta):
	process_move(delta)
