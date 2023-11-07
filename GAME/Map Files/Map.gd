extends GridMap
class_name Map

var thread: Thread
# Called when the node enters the scene tree for the first time.
func _ready():
	thread = Thread.new()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func bake():
	thread.start(bake_navmesh)


func bake_navmesh():
	get_meshes()
