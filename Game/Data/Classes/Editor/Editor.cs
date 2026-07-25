using Godot;
using System;

public partial class Editor : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	/// <summary>
	/// Creates a new map.
	/// </summary>
	/// <param name="mapSize">Size of the new map in chunks.</param>
	/// <param name="initialDepth"></param>
	/// <returns></returns>
	public static MapData GenerateNewMap(Vector2I mapSize, byte initialDepth, byte chunkSize = 16)
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
				byte newHeight = 6;//(byte)(chunkPos.X + chunkPos.Y);

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
}
