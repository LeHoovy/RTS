@tool
class_name NewMapDialogue
extends Panel


var _parent_window: Window


func _ready() -> void:
	if get_parent() is not Window:
		print("Parent isn't a window, freeing memory")
		queue_free()
	_parent_window = get_parent()


func _on_cancel_pressed() -> void:
	_parent_window.queue_free()
