#@tool
extends Node


@export var editor: MapEditorGDScript
var _selected := false
var selection: EditorSelection


func _ready() -> void:
	editor = %MapEditor
	
	if Engine.is_editor_hint():
		selection = EditorInterface.get_selection()
		selection.connect("selection_changed", _on_selection_changed)
	else:
		_selected = true
		editor.terrain_brush_active = true


func _on_selection_changed() -> void:
	# Makes sure only the brush is selected
	if self not in selection.get_selected_nodes():
		if editor.terrain_brush_active:
			editor.terrain_brush_active = false
			_selected = false
		return
	if selection.get_selected_nodes().size() != 1:
		_selected = false
		print()
		print("Brush is not the only selected, cancelling process")
		print("Please only select the brush tool")
		editor.terrain_brush_active = false
		return
	
	if not editor.terrain_brush_active:
		_selected = true
		editor.terrain_brush_active = true
