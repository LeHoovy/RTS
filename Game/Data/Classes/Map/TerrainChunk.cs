using Godot;
using System;

[GlobalClass]
public partial class TerrainChunk : Resource
{
	// TODO:
	// Create terrain from the heightmap probes
	// Create a navmesh from the terrain

	public Vector2I Position; // Position relative to other chunks/to the map.
	public byte[,] LocalHeightMap; // The heightmap that is contained on the chunk.
	public HeightMapProbe[,] Probes;
	private HeightMapProbe[,] terrainCorners;


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
		// Prepares the new chunk and sets its stored variables
		TerrainChunk newChunk = new TerrainChunk();
		newChunk.Position = position;
		newChunk.LocalHeightMap = ArrayHelper.Slice2DArray(heightmap, position.X, size, position.Y, size);

		// Initializes the new chunk's probe array
		newChunk.Probes = new HeightMapProbe[
			newChunk.LocalHeightMap.GetLength(0) + 1,
			newChunk.LocalHeightMap.GetLength(1) + 1
		];

		// Iterate over every position in the probe array to generate a probe
		// Something seems wrong here, like the Probes heightmap is off by the chunks position
		// Maybe in the probe's script?
		for (int x = 0; x < newChunk.LocalHeightMap.GetLength(0) + 1; x++)
		{
			for (int y = 0; y < newChunk.LocalHeightMap.GetLength(1) + 1; y++)
			{
				newChunk.Probes[x, y] = HeightMapProbe.NewProbe(new Vector2I(x, y), position * 16, heightmap);
				Vector2I probeWorldPos = newChunk.Probes[x, y].Position + newChunk.Position * 16;
				if (probeWorldPos == new Vector2I(16, 3))
				{
					GD.Print($"chunk {newChunk.Position}: {probeWorldPos}");
				}
			}
		}
		//GD.Print("Probes Created!");
		return newChunk;
	}


	/// <summary>
	/// Regenerates the entirety of the chunk's 3D terrain.
	/// </summary>
	public void GenerateTerrain()
	{
		
	}
}
