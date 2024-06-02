extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in get_used_cells():
		print('POSITION: ', cell, ' ORIENTATION: ', get_cell_item_orientation(cell))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
