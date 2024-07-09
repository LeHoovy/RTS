extends Area2D
class_name Tri



var triangle: CollisionPolygon2D
var ready_passed: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await child_entered_tree
	triangle = get_node("Triangle")
	ready_passed = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func reposition_vertex(vertex: int, new_position: Vector2i) -> void:
	print(triangle, ' ', ready_passed)
	var vertex_new_pos: Vector2 = Vector2(new_position)
	triangle.polygon[vertex] = vertex_new_pos
