using Godot;
using System;

[GlobalClass]
public partial class TerrainChunk : Resource
{
	public Vector2I Position; // Position relative to other chunks/to the map.
	public byte[,] LocalHeightMap; // The heightmap that is contained on the chunk.
	private TerrainProbe[,] terrainProbes;


	/// <summary>
	/// Converts a tile position into a heightmap position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Tile position we want to find the heightmap position of.</param>
	/// <returns>Heightmap position of the given tile.
	/// If the tile is not on the map, returns 0.</returns>
	private uint ConvertPos(Vector2I pos)
	{
		if (pos.X < 0 || pos.X >= 16)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}
		if (pos.Y < 0 || pos.Y >= 16)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}

		return (uint)(pos.X + (pos.Y * 16));
	}


	/// <summary>
	/// Converts a heightmap position to a map position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Position on the heightmap to convert to a map position.</param>
	/// <returns>Returns the tile position of the given heightmap position.
	/// Returns the (-1, -1) if the given position does not exist..</returns>
	private Vector2I ConvertPos(uint pos)
	{
		if (pos >= 256)
		{
			GD.PrintErr($"Position ''{pos}'' is out of range. Max range: {255}");
			GD.PushError($"Position ''{pos}'' is out of range. Max range: {255}");
			return new Vector2I(-1, -1);
		}

		return new Vector2I((int)pos % 16, (int)Math.Floor((double)pos / 16));
	}


	/// <summary>
	/// Creates a new chunk from a position and the local heightmap.
	/// </summary>
	/// <param name="position">The chunk's position on the map</param>
	/// <param name="heightmap">The chunk's local heightmap</param>
	/// <returns>The new chunk</returns>
	public static TerrainChunk NewChunk(Vector2I position, byte[,] heightmap, byte size)
	{
		TerrainChunk newChunk = new TerrainChunk();
		newChunk.Position = position;
		newChunk.LocalHeightMap = ArrayHelper.Slice2DArray(heightmap, position.X, size, position.Y, size);

		newChunk.terrainProbes = new TerrainProbe[
			heightmap.GetLength(0) + 1,
			heightmap.GetLength(1) + 1
		];
		for (int y = 0; y < newChunk.LocalHeightMap.GetLength(1) + 1; y++)
		{
			for (int x = 0; x < newChunk.LocalHeightMap.GetLength(0) + 1; x++)
			{
				newChunk.terrainProbes[x, y] = TerrainProbe.NewProbe(new Vector2I(x, y), heightmap);
			}
		}

		return newChunk;
	}
}
