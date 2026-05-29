using Godot;
using System;

public partial class TerrainRegion : RefCounted
{
	// INFO:
	// this class will only be created as a child of TerrainChunk classes for the purpose of generating terrain.
	// Position will be relative to the parent chunk's position.
	// I.E it will only go from (0, 0) to (15, 15)


	public Vector3I[] Corners; // The third position is used for height.
	// INFO:
	// When creating 3D terrain, switch Y and Z.
	// Otherwise it will not be correct
}
