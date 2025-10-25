class_name map_gen
extends Node3D

# TODO:
# Make a chunk system
# Chunk up map corners, so the chunks hold regions of the map
# Send map corners to navmesh generator
# Navigation will be unrelated to chunks, but chunks will be used for performance in rendering

# Chunks should probably have their own classes
# If chunks are their own classes, instances, or even scenes, might not need this to extend Node3D


# Contains points on the map and what other points they are connected to
# i.e a point at (0, 0, 0) could connect to (2, 0, 0), (0, 2, 0), and (0, 0, 2)
# Essentially just the corners. Should be useful for generating meshes and navmeshes
# Should contain ramps, or at least points where ramps might connect
var _map_corners: Dictionary[Vector3, Array]
var chunks: Array[Node3D]