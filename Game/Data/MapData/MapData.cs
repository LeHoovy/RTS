using Godot;
using System;
using System.Runtime.CompilerServices;
using Range = Godot.Range;

public partial class MapData : Resource
{
	public byte[] heightmap;


	public static MapData NewMap(Vector2I mapSize, byte initialDepth)
	{
		MapData newMap = new MapData();

		for (byte x = 0; x < mapSize.X; x++)
		{
			for (byte y = 0; y < mapSize.Y; y++)
			{
				
			}
		}

		return newMap;
	}
}
