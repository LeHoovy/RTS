using Godot;
using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using Range = Godot.Range;

public partial class MapData : Resource
{
	public byte[,] HeightMap;
	public Vector2I MapSize;


	/// <summary>
	/// Creates a new map.
	/// </summary>
	/// <param name="mapSize">Size of the new map in chunks.</param>
	/// <param name="initialDepth"></param>
	/// <returns></returns>
	public static MapData NewMap(Vector2I mapSize, byte initialDepth, byte chunkSize = 16)
	{
		//ulong startTime = Time.GetTicksUsec();
		mapSize = mapSize.Clamp(0, 65536); // Ensure the map isn't too large to store
		MapData newMap = new MapData
		{
			MapSize = mapSize * chunkSize,
			HeightMap = new byte[mapSize.X * chunkSize, mapSize.Y * chunkSize]
		};

		//newMap.HeightMap = new byte[newMap.MapSize.X * newMap.MapSize.Y];
		GD.Print(newMap.HeightMap.Length);
		for (uint XPos = 0; XPos < newMap.HeightMap.GetLength(0); XPos++)
		{
			for (uint YPos = 0; YPos < newMap.HeightMap.GetLength(1); YPos++)
			{
				// just debug mapgen stuff, really
				// so I don't need to create map modification stuff just yet
				Vector2I tilePos = new Vector2I((int)XPos, (int)YPos);
				Vector2I chunkPos = newMap.GetChunkAtPos(tilePos);
				byte newHeight = (byte)(chunkPos.X + chunkPos.Y);

				if ((tilePos.X % chunkSize) + 1 < (tilePos.Y % chunkSize))
				{
					newHeight += 4;
				}

				newMap.HeightMap[XPos, YPos] = (byte)(newHeight * chunkSize);
				//newMap.HeightMap[XPos] = (byte)(initialDepth * 8);
			}
		}

		// Print out how long it took to generate the new map
		/*ulong endTime = Time.GetTicksUsec();
		GD.Print($"Time elapsed:\n{endTime-startTime} microseconds\n{Math.Round((endTime-startTime) / 100.0) / 10} milliseconds");
		GD.Print();*/

		return newMap;
	}


	/// <summary>
	/// Finds a chunk containing a given tile.
	/// </summary>
	/// <param name="pos"></param>
	/// <returns>Chunk position that contains the given position.</returns>
	public Vector2I GetChunkAtPos(Vector2I pos)
	{
		if (pos.X < 0 || pos.X >= MapSize.X)
		{
			GD.PrintErr("Warning: Position not on map! Returned chunk will not exist!");
			GD.PushWarning("Warning: Position not on map! Returned chunk will not exist!");
		} else if (pos.Y < 0 || pos.Y >= MapSize.Y)
		{
			GD.PrintErr("Warning: Position not on map! Returned chunk will not exist!");
			GD.PushWarning("Warning: Position not on map! Returned chunk will not exist!");
		}

		Vector2I chunkPos = new Vector2I(0, 0);
		chunkPos.X = (int)Math.Floor(pos.X / 16.0);
		chunkPos.Y = (int)Math.Floor(pos.Y / 16.0);
		return chunkPos;
	}


	/// <summary>
	/// Overload for GetChunkAtPos() that takes a heightmap position.<br/>
	/// Finds a chunk at a given position.<br/>
	/// In theory should always return a real chunk as it converts through ConvertPos() first.
	/// </summary>
	/// <param name="pos">A position on the heightmap.</param>
	/// <returns>Chunk position that contains the given position.</returns>
	public Vector2I GetChunkAtPos(uint pos)
	{
		return GetChunkAtPos(ConvertPos(pos));
	}


	/// <summary>
	/// Converts a tile position into a heightmap position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Tile position we want to find the heightmap position of.</param>
	/// <returns>Heightmap position of the given tile.
	/// If the tile is not on the map, returns 0.</returns>
	private uint ConvertPos(Vector2I pos)
	{
		if (pos.X < 0 || pos.X >= MapSize.X)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}
		if (pos.Y < 0 || pos.Y >= MapSize.Y)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}

		return (uint)(pos.X + (pos.Y * MapSize.X));
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
		if (pos > HeightMap.Length)
		{
			GD.PrintErr($"Position ''{pos}'' is out of range. Max range: {HeightMap.Length}");
			GD.PushError($"Position ''{pos}'' is out of range. Max range: {HeightMap.Length}");
			return new Vector2I(-1, -1);
		}

		return new Vector2I((int)pos % MapSize.X, (int)Math.Floor((double)pos / MapSize.X));
	}
}
