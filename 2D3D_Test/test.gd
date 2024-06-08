extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for cell in get_used_cells():
		print('POSITION: ', cell, ' ORIENTATION: ', get_cell_item_orientation(cell))
	
	var test_arr: Array[Variant] = [0, 2, 7, 'apple', 'banana', 'cat', true, 3.2]
	print(test_arr)
	test_arr[test_arr.rfind('cat')] = false
	print(test_arr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
