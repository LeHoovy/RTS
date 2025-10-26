class_name Map
extends Node
# Stores map information
# Imports and exports map information to jsons in order to save map data
# Generates chunks
# Generates navmesh based on map geometry and doodad locations

const CHUNK_SIZE := Vector2i(32, 32)
