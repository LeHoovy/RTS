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
		MapData newMap = new MapData();
		newMap.MapSize = mapSize * 16;

		newMap.HeightMap = new byte[newMap.MapSize.X * newMap.MapSize.Y];
		GD.Print(newMap.HeightMap.Length);
		int iteration = 0;
		for (byte y = 0; y < newMap.MapSize.Y; y++)
		{
			for (byte x = 0; x < newMap.MapSize.X; x++)
			{
				if (iteration > newMap.MapSize.X * newMap.MapSize.Y)
				{
					GD.PrintErr($"Iteration ({iteration}) is too high!");
					return newMap;
				}

				// Get chunk pos
				Vector2I chunkPos = new Vector2I((int)Math.Floor(x / 16.0), (int)Math.Floor(y / 16.0));
				GD.Print($"Tile: ({x}, {y}) in chunk: {chunkPos}");
				int newHeight = (int)(Math.Floor(x / 16.0) + y);
				/*if (x > y)
				{
					newHeight = (byte)(newHeight + 1);
				}*/

				newMap.HeightMap[newMap.TileToHeightMapPos(new Vector2I(x, y))] = (byte)(newHeight * 32 % 255);//(byte)(initialDepth * 8);
				
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
	/// Takes a specific map tile and returns what position in the HeightMap that tile's data would be found.
	/// </summary>
	/// <param name="tile">Vector2I containing the location of the tile that we want to get the HeightMap position of. Must be on the map.</param>
	/// <returns>If the tile's location exists on the map, returns what position in the HeightMap it is found. If not, returns 0.</returns>
	private ushort TileToHeightMapPos(Vector2I tile)
	{
		if (tile.X < 0 || tile.X >= MapSize.X)
		{
			GD.PrintErr($"Could not find a tile at position ({tile.X}, {tile.Y})!");
			GD.PushError($"Could not find a tile at position ({tile.X}, {tile.Y})!");
			return 0;
		}
		if (tile.Y < 0 || tile.Y >= MapSize.Y)
		{
			GD.PrintErr($"Could not find a tile at position ({tile.X}, {tile.Y})!");
			GD.PushError($"Could not find a tile at position ({tile.X}, {tile.Y})!");
			return 0;
		}

		return (ushort)(tile.X + (tile.Y * 16));
	}


	/// <summary>
	/// Takes a position in the heightmap and converts it to a tile position on the map.
	/// </summary>
	/// <param name="mapPos">A position on the heightmap.</param>
	/// <returns>(-1, -1) if "mapPos" is not on the heightmap. Otherwise returns the tile position of the heightmap position.</returns>
	private Vector2I HeightMapPosToTile(ushort mapPos)
	{
		if (mapPos > HeightMap.Length)
		{
			GD.PrintErr($"Position ''{mapPos}'' is out of range. Max range: {HeightMap.Length}");
			GD.PushError($"Position ''{mapPos}'' is out of range. Max range: {HeightMap.Length}");
			return new Vector2I(-1, -1);
		}

		return new Vector2I(mapPos % 16, (int)Math.Floor((double)mapPos / 16));
	}
}
