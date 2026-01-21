using Godot;
using Godot.Collections;
using System;

public partial class MapData : Resource
{
	[Export]
	public string Name = null; // The map's name
	[Export]
	public string StoragePos = null; // path/to/data.tres within Map.FilePath. If null, go to Name/data.tres
	[Export]
	public Vector2I Size; // Size of the map in integer tiles
	[Export]
	public byte[] HeightMap = null; // The heightmap used to generate terrain
	/* TODO: Finish and use these
	[Export]
	public Array<Vector2I> Ramps; // Used to add ramps to the terrain, stores highground ramp positions
	[Export]
	public Dictionary<string, Variant> Doodads; // Stores doodads, their positions, and any changes applied to them (rotation, scale, etc.)
	[Export]
	public Dictionary<string, Variant> Entities; // Stores entities, their positions, and any changes applied to them (stats, abilities, etc.)
	*/

	/// <summary>
	/// Called to find the height of a specific tile on the map.
	/// </summary>
	/// <param name="tile">Position of the tile on the map you wish to find the height of.</param>
	/// <returns>The height of <paramref name="tile"/>.</returns>
	public byte GetHeightOfTile(Vector2I tile)
	{
		int posInArray = tile.Y * Size.X;
		posInArray += tile.X;

		return HeightMap[posInArray];
	}
}
