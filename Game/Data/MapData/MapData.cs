using Godot;
using System;
using System.Numerics;
using System.Runtime.CompilerServices;
using Range = Godot.Range;

public partial class MapData : Resource
{
	public byte[] HeightMap;
	public Vector2I MapSize;


	/// <summary>
	/// Creates a new map.
	/// </summary>
	/// <param name="mapSize"></param>
	/// <param name="initialDepth"></param>
	/// <returns></returns>
	public static MapData NewMap(Vector2I mapSize, byte initialDepth)
	{
		MapData newMap = new MapData
		{
			MapSize = mapSize * 16,
			HeightMap = new byte[mapSize.X * 16 * mapSize.Y * 16]
		};

		//newMap.HeightMap = new byte[newMap.MapSize.X * newMap.MapSize.Y];
		GD.Print(newMap.HeightMap.Length);
		int iteration = 0;
		for (byte y = 0; y < newMap.MapSize.Y; y++)
		{
			for (byte x = 0; x < newMap.MapSize.X; x++)
			{
				if (iteration > newMap.MapSize.X * newMap.MapSize.Y)
				{
					GD.PrintErr($"Iteration ({iteration}) is too high!");
					GD.PushError($"Iteration ({iteration}) is too high!");
					return newMap;
				}

				// DEBUG MAP GEN
				// Get chunk pos
				Vector2I chunkPos = newMap.GetChunkAtPos(new Vector2I(x, y));
				int newHeight = (int)(chunkPos.X * 2 + chunkPos.Y * 2);
				if (x % 16 > y % 16)
				{
					newHeight = (byte)(newHeight + 1);
				}

				newMap.HeightMap[newMap.ConvertPos(new Vector2I(x, y))] = (byte)(newHeight * 16 % 255);
				// Final. Use later and comment out/delete the previous code as it will be unneeded
				//newMap.HeightMap[newMap.ConvertPos(new Vector2I(x, y))] = (byte)(initialDepth * 8);

				iteration++;

				if (x == 255)
				{
					break;
				}
			}
			if (y == 255)
			{
				break;
			}
		}

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
	/// Finds a chunk at a given position.
	/// </summary>
	/// <param name="pos">A position on the heightmap.</param>
	/// <returns>Chunk position that contains the given position.</returns>
	public Vector2I GetChunkAtPos(ushort pos)
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
	private ushort ConvertPos(Vector2I pos)
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

		return (ushort)(pos.X + (pos.Y * MapSize.X));
	}


	/// <summary>
	/// Converts a heightmap position to a map position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Position on the heightmap to convert to a map position.</param>
	/// <returns>Returns the tile position of the given heightmap position.
	/// Returns the (-1, -1) if the given position does not exist..</returns>
	private Vector2I ConvertPos(ushort pos)
	{
		if (pos > HeightMap.Length)
		{
			GD.PrintErr($"Position ''{pos}'' is out of range. Max range: {HeightMap.Length}");
			GD.PushError($"Position ''{pos}'' is out of range. Max range: {HeightMap.Length}");
			return new Vector2I(-1, -1);
		}

		return new Vector2I(pos % MapSize.X, (int)Math.Floor((double)pos / MapSize.X));
	}
}
