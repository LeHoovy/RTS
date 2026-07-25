using Godot;
using System;

public partial class TerrainRegion : RefCounted
{
	// INFO:
	// this class will only be created as a child of TerrainChunk classes for the purpose of generating terrain.
	// Position will be relative to the parent chunk's position.
	// I.E it will only go from (0, 0) to (15, 15)


	public Vector2I[] Corners; // Where the corners corners of the region are
	public byte[] CornerHeights; // Mainly used for ramps
}
