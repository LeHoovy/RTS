extends CharacterBody2D

@export var size: int = 75



# Called when the node enters the scene tree for the first time.
func _ready():
	if size < 0.5:
		size = 0.5
	
	scale.x = float(size) / 100
	scale.y = float(size) / 100



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
