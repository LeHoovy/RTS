@tool
class_name NewMapDialogue
extends Panel


var _parent_window: Window


func _ready() -> void:
	if self == get_tree().edited_scene_root:
		print("Scene opened in editor, scene is not new window, ignoring")
		return
	if get_parent() is not Window:
		print("Parent isn't a window, scene is not open in editor, freeing memory")
		queue_free()
	_parent_window = get_parent()


func _on_cancel_pressed() -> void:
	_parent_window.queue_free()
