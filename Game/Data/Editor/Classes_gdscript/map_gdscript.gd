class_name MapGDScript
extends Node
# Stores map information
# Imports and exports map information to jsons in order to save map data
# Generates chunks
# Generates navmesh based on map geometry and doodad locations

const CHUNK_SIZE := Vector2i(32, 32)

var chunks: Array[MapChunkGDScript]
var chunk_container: Node


func _ready() -> void:
	chunk_container = get_node_or_null("Chunks")
	if chunk_container == null:
		print_rich("[color=yellow]Warning: Chunk container node does exist, creating new node.")
		chunk_container = Node.new()
		chunk_container.name = "Chunks"
		add_child(chunk_container)
