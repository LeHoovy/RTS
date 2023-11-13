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
	cam_move_speed += move * (0.3 * (edge_scroll_sens / 3)) 
	#cam_move_speed *= friction
	cam_move_speed = clamp(cam_move_speed, Vector2(-edge_scroll_sens / 3, -edge_scroll_sens / 3), Vector2(edge_scroll_sens / 3, edge_scroll_sens / 3))
	
	if move.x == 0:
		cam_move_speed.x = 0
	if move.y == 0:
		cam_move_speed.y = 0
	
	#print(cam_move_speed)
	position.x += cam_move_speed.x * delta
	position.z += cam_move_speed.y * delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
var mouse_pos: Vector2
var screen_size: Vector2
var cam_move_speed: Vector2
func _process(delta):
	process_move(delta)


var zoomSpeed: float = 0.05
var zoomMin: float = 0.3
var zoomMax: float = 5.0
var zoom: float = 1
#Sets the minimum and maximum zoom, as well as the speed of zooming.
@export var dragSens: float = 4
#Changes the sensitivity of the ability to drag around the camera.

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position.x -= event.relative.x / 49.5
		position.z -= event.relative.y / 50
#Repositions the camera as long as the middle mouse button (mouse 3) is pressed
#Relative to the sensitivity and movement of the mouse.
#Also adjusts based on the zoom amount.
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += zoomSpeed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= zoomSpeed
		#Changes zoom as long, and only if, the mouse wheel is being scrolled
		zoom = clamp(zoom, zoomMin, zoomMax)
