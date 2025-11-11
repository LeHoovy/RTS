@tool
extends Node


@export var editor: MapEditor
var selection: EditorSelection = EditorInterface.get_selection()


func _ready() -> void:
	selection.connect("selection_changed", _on_selection_changed)


func _on_selection_changed() -> void:
	# Makes sure only the brush is selected
	if self not in selection.get_selected_nodes():
		if editor.terrain_brush_active:
			editor.terrain_brush_active = false
		return
	if selection.get_selected_nodes().size() != 1:
		if editor.terrain_brush_active:
			editor.terrain_brush_active = false
		print()
		print("Brush is not the only selected, cancelling process")
		print("Please only select the brush tool")
		return
	
	if not editor.terrain_brush_active:
		editor.terrain_brush_active = true
