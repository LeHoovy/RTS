class_name MapChunk
extends Node3D
# Use this later to show the map
# Chunks can probably store their own data such as exploration and triggers
# Doodads will be stored in chunks
# Each chunk will have its own available placement tiles
# These tiles interact with the entity system and make sure no cliffs or doodads can be built on
# Additionally might check for ramps
# 
# Order of operations
# 1. Generate Mesh
# 2A Texture Mesh
# 2B Load and place cliff assets as children
# 3. Load and place doodad assets as children
# 2A and 2B may come in either order depending on cliff asset used
