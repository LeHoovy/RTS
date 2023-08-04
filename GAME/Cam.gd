extends Camera2D

var zoomSpeed: float = 0.05
var zoomMin: float = 0.3
var zoomMax: float = 5.0
#Sets the minimum and maximum zoom, as well as the speed of zooming.
@export var dragSens: float = 1.0
#Changes the sensitivity of the ability to drag around the camera.

func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position -= event.relative * dragSens / zoom
#Repositions the camera as long as the middle mouse button (mouse 3) is pressed
#Relative to the sensitivity and movement of the mouse.
#Also adjusts based on the zoom amount.
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoomSpeed, zoomSpeed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoomSpeed, zoomSpeed)
		#Changes zoom as long, and only if, the mouse wheel is being scrolled
		zoom = clamp(zoom, Vector2(zoomMin, zoomMin), Vector2(zoomMax, zoomMax))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
