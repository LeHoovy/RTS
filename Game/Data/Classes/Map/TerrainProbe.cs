using Godot;
using System;

[GlobalClass]
public partial class TerrainProbe : Resource
{
	// Constant variables
	public enum ProbeType // What type is the probe
	{
		Flat,    //0: Flat tile.
		Edge,    //1: Contains an edge, but otherwise the same as a flat tile.
		Corner,  //2: Contains a corner. Used to generate polygons.
		Junction //3: Contains a corner and an edge. Used to generate polygons.
	}

	// Standard variables
	public Vector2I Position; // Position relative to the owner chunk.
	public Vector2I InChunk; // What chunk the probe is in.
	private bool isCorner; // If the probe is a corner, use for quick checks
	private byte?[,] localHeightmap; // Local heightmap. Should be a 4x4 grid.

	// Static variables
#pragma warning disable CA2211 // Non-constant fields should not be visible
	public static ulong Probes; // Debug value for counting how many terrain probes are created.
#pragma warning restore CA2211 // Non-constant fields should not be visible


	/// <summary>
	/// Returns the type of the probe and sets if it is a corner or not.
	/// Might need to be public but was private before
	/// </summary>
	/// <param name="pos">What position (0,0) - (2,2) to check on the local heightmap</param>
	/// <returns></returns>
	public ProbeType CheckType(bool updateCorner = false)
	{
		// The main 4 tiles the probe covers
		byte?[,] primaryTiles = ArrayHelper.Slice2DArray(localHeightmap, 1, 2, 1, 2);

		// debug print stuff
		//GD.Print(Position);
		//ArrayHelper.Print2DArray(localHeightmap);
		//ArrayHelper.Print2DArray(primaryTiles);

		// If each position is the same height, it is flat
		if (primaryTiles[0, 0] == primaryTiles[0, 1]
			&& primaryTiles[0, 1] == primaryTiles[1, 1]
		   && primaryTiles[1, 1] == primaryTiles[1, 0])
		{
			return ProbeType.Flat;
		}

		// If two positions equal each other and another two positions equal each other
		// it is an edge
		if ((primaryTiles[0, 0] == primaryTiles[1, 0]
			&& primaryTiles[0, 1] == primaryTiles[1, 1]
			&& primaryTiles[0, 0] != primaryTiles[0, 1]
			) || (
			primaryTiles[0, 0] == primaryTiles[0, 1]
			&& primaryTiles[1, 0] == primaryTiles[1, 1]
			&& primaryTiles[0, 0] != primaryTiles[1, 0])
			)
		{
			return ProbeType.Edge;
		}

		//GD.Print(Position);
		// Now to figure out if it's a corner or diagonal
		Func<int, int> xPos = n => Math.Clamp(n % 3, 0, 1);
		Func<int, int> yPos = n => n / 2;
		for (byte i = 0; i < 4; i++)
		{
			var posOne = primaryTiles[xPos(i), yPos(i)];
			var posTwo = primaryTiles[xPos((i + 1) % 4), yPos((i + 1) % 4)];
			var posThree = primaryTiles[xPos((i + 2) % 4), yPos((i + 2) % 4)];
			var posFour = primaryTiles[xPos((i + 3) % 4), yPos((i + 3) % 4)]; //ERROR: out of bounds

			if (posOne is null
			|| posTwo is null
			|| posThree is null
			|| posFour is null)
			{
				return ProbeType.Corner;
			}

			// Not a single tile is the same height
			if (posOne != posTwo
			&& posTwo != posThree
			&& posThree != posFour
			&& posThree != posOne
			&& posFour != posOne
			&& posFour != posTwo)
			{
				return ProbeType.Corner;
			}

			// Three-way junction
			if ((posOne != posTwo // Vertical check
			&& posTwo != posThree
			&& posThree != posOne
			&& posTwo == posFour)
			|| (posOne == posTwo // Horizontal/Diagonal check
			&& posTwo != posThree // Technically diagonal would be a four-way junction
			&& posThree != posFour
			&& posFour != posOne))
			{
				return ProbeType.Corner;
			}
			//GD.Print(xPos(
		}

		return ProbeType.Flat;
	}


	/// <summary>
	/// Creates a new TerrainProbe instance. Performs its own slicing on a heightmap.
	/// </summary>
	/// <param name="position">The chunk's position on the map</param>
	/// <param name="heightmap">The chunk's local heightmap</param>
	/// <returns>A terrain probe.</returns>
	public static TerrainProbe NewProbe(Vector2I pos, Vector2I chunkPos, byte[,] heightmap, bool doPreCheck = false)
	{
		Probes += 1;

		TerrainProbe probe = new TerrainProbe();
		probe.Position = pos;
		probe.localHeightmap = new byte?[4, 4];
		//GD.Print(pos);
		for (int x = -2; x < 2; x++)
		{
			for (int y = -2; y < 2; y++)
			{
				// Ensures the position actually exists.
				if (chunkPos.Y + y + pos.Y < 0 || chunkPos.Y + y + pos.Y >= heightmap.GetLength(1))
				{
					probe.localHeightmap[x + 2, y + 2] = null;
					continue;
				}
				if (chunkPos.X + x + pos.X < 0 || chunkPos.X + x + pos.X >= heightmap.GetLength(0))
				{
					probe.localHeightmap[x + 2, y + 2] = null;
					continue;
				}

				probe.localHeightmap[x + 2, y + 2] = heightmap[chunkPos.X + x + pos.X, chunkPos.Y + y + pos.Y];
			}
		}
		//ArrayHelper.Print2DArray(probe.localHeightmap);
		return probe;
	}
}
