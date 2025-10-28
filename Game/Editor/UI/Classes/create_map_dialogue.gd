@tool
class_name NewMapDialogue
extends Panel


var _parent_window: Window
var _new_map_x_input: OptionButton
var _new_map_y_input: OptionButton
var _create_button: Button
var _cancel_button: Button


func _ready() -> void:
	if get_parent() is not Window:
		print("Parent isn't a window, freeing memory")
		queue_free()
	_parent_window = get_parent()

	_new_map_y_input = (
			get_node("VBoxContainer/Y Axis/Options/HBoxContainer/Control3/Options")
	) as OptionButton
	_new_map_x_input = (
			get_node("VBoxContainer/X Axis/Options/HBoxContainer/Control3/Options")
	) as OptionButton

	_create_button = get_node("VBoxContainer/Confirmation/Create") as Button
	_cancel_button = get_node("VBoxContainer/Confirmation/Cancel") as Button

	_cancel_button.pressed.connect(_on_cancel_pressed)
	_create_button.pressed.connect(_on_create_pressed)


func _on_cancel_pressed() -> void:
	_parent_window.queue_free()


func _on_create_pressed() -> void:
	pass