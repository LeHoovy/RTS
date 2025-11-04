@tool
extends Panel


# Parent window and map editor vars for storage
var _parent_window: Window
var _map_editor: MapEditor

var _new_map_x_input: OptionButton
var _new_map_y_input: OptionButton
var _cancel_button: Button
var _create_button: Button


func _ready() -> void:
	# First make sure this isn't opened in the editor
	# If it isn't, and it can't find the MapEditor node, free its memory
	# If it also isn't opened in a new window, free its memory
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
	_map_editor = get_tree().edited_scene_root.get_node("MapEditor") as MapEditor
	
	# Set up option input variables
	_new_map_y_input = (
			get_node("VBoxContainer/Y Axis/Options/HBoxContainer/Control3/Options")
	) as OptionButton
	_new_map_x_input = (
			get_node("VBoxContainer/X Axis/Options/HBoxContainer/Control3/Options")
	) as OptionButton
	
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
	var new_map_size := Vector2(
			int(_new_map_x_input.get_item_text(_new_map_x_input.selected)),
			int(_new_map_y_input.get_item_text(_new_map_y_input.selected)),
	)
	
	_map_editor.make_new_map(new_map_size)
	await get_tree().process_frame
	_parent_window.queue_free()
