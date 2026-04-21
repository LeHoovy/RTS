using Godot;
using System;

public partial class TerrainProbe : Resource
{
	public Vector2I Position; // Position relative to the owner chunk.
	private byte?[,] localHeightmap; // Local heightmap. Should be a 4x4 grid.


	/// <summary>
	/// Creates a new TerrainProbe instance. Performs its own slicing on a heightmap.
	/// </summary>
	/// <param name="position">The chunk's position on the map</param>
	/// <param name="heightmap">The chunk's local heightmap</param>
	/// <returns>A terrain probe.</returns>
	public static TerrainProbe NewProbe(Vector2I pos, byte[,] heightmap)
	{
		TerrainProbe probe = new TerrainProbe();
		probe.Position = pos;
		probe.localHeightmap = new byte?[4, 4];
		GD.Print(pos);
		for (int x = -2; x < 2; x++)
		{
			for (int y = -2; y < 2; y++)
			{
				// Ensures the position actually exists.
				if (y + pos.Y < 0 || y + pos.Y >= heightmap.GetLength(1))
				{
					probe.localHeightmap[x + 2, y + 2] = null;
					continue;
				}
				if (x + pos.X < 0 || x + pos.X >= heightmap.GetLength(0))
				{
					probe.localHeightmap[x + 2, y + 2] = null;
					continue;
				}

				probe.localHeightmap[x + 2, y + 2] = heightmap[x + pos.X, y + pos.Y];
			}
		}
		//ArrayHelper.Print2DArray(probe.localHeightmap);

		return probe;
	}
}
