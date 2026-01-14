extends Panel


# Parent window and map editor vars for storage
var _parent_window: Window
var _map_editor: MapEditor

var _map_width: OptionButton
var _map_height: OptionButton
var _map_depth: OptionButton
var _map_name: TextEdit
var _cancel_button: Button
var _create_button: Button


func _ready() -> void:
	# First make sure this isn't opened in the editor
	# If it isn't, and it can't find the MapEditor node, free its memory
	# If it also isn't opened in a new window, free its memory
	if Engine.is_editor_hint():
		if self == get_tree().edited_scene_root:
			print("Scene opened in editor, scene is not new window, ignoring")
			return
		if not get_tree().edited_scene_root.has_node("MapEditor"):
			print("Not opened from map editor scene, freeing memory")
			queue_free()
	if get_parent() is not Window:
		print("Parent isn't a window, scene is not open in editor, freeing memory")
		queue_free()
	
	# Finally, set your parent window variable to your parent window
	# And map editor to map editor node
	_parent_window = get_parent()
	if Engine.is_editor_hint():
		_map_editor = get_tree().edited_scene_root.get_node("MapEditor") as MapEditor
	else:
		_map_editor = get_parent().get_parent() as MapEditor
	
	## Set up option input variables
	# Map Size
	_map_width = get_node("%Width Option") as OptionButton
	_map_height = get_node("%Height Option") as OptionButton
	_map_depth = get_node("%Depth option") as OptionButton
	# Map Data
	_map_name = get_node("%Map Name") as TextEdit
	
	# Set up and connect signals of confirmation buttons
	_create_button = get_node("VBoxContainer/Confirmation/Create") as Button
	_cancel_button = get_node("VBoxContainer/Confirmation/Cancel") as Button
	_cancel_button.pressed.connect(_on_cancel_pressed)
	_create_button.pressed.connect(_on_create_pressed)


# When operation is cancelled, delete the window
func _on_cancel_pressed() -> void:
	_parent_window.queue_free()


# When operation is confirmed, send the output to the map editor node
func _on_create_pressed() -> void:
	if _map_name.text == "":
		_map_name.placeholder_text = "A map name is required. Please enter one here"
		return
	
	var new_map_size := Vector3i(
			int(_map_width.get_item_text(_map_width.selected)),
			int(_map_height.get_item_text(_map_height.selected)),
			int(_map_depth.get_item_text(_map_depth.selected)),
	)
	
	var output: Dictionary[String, Variant] = {
		"Name": _map_name.text,
		"Size": new_map_size,
	}
	
	#(_map_editor.get_parent().get_node("MapData") as MapData).map_size = new_map_size
	_map_editor.map_creation_output = output
	await get_tree().process_frame
	_parent_window.queue_free()
