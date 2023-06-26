extends Sprite2D

var heat = 0
var root = get_parent()
var relPos = Vector2i()

func locate():
	print(relPos)


func toggleVisibility():
	if frame == 0:
		rotation_degrees = 0
		frame = 1
	else:
		frame = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
