using Godot;
using System;
using System.ComponentModel;

[GlobalClass]
public partial class MapHandler : Node
{
	// General Variables
	public MapData Data;
	private TerrainChunk[,] chunks;

	// Export items
	[ExportGroup("Standard")]
	[Export]
	public byte ChunkSize = 16;
	[ExportGroup("Debug")]
	[Export]
	public bool Debug;
	[Export]
	public Node DebugParent;
	[Export]
	public Vector2I MapSize = new Vector2I(16, 16);

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		ulong startTime = Time.GetTicksUsec();
		if (Data is null) // If there is no map data, generate a new one.
		{
			Data = MapData.NewMap(MapSize, 4, ChunkSize);
		}
		
		Vector2I size = Data.MapSize;
		Vector2I chunkMapSize = size / ChunkSize;
		chunks = new TerrainChunk[chunkMapSize.X, chunkMapSize.Y];
		GD.Print(chunkMapSize);
		// Create chunks
		for (uint chunkX = 0; chunkX < chunks.GetLength(0); chunkX++)
		{
			for (uint chunkY = 0; chunkY < chunks.GetLength(1); chunkY++)
			{
				TerrainChunk newChunk = TerrainChunk.NewChunk(
					new Vector2I((int)chunkX, (int)chunkY),
					Data.HeightMap,
					ChunkSize
				);
				//newChunk.Position = new Vector2I((int)chunkX, (int)chunkY);
				chunks[chunkX, chunkY] = newChunk; // Store the new chunk in the Chunk Array
			}
		}
		GD.Print($"Total Terrain Probes: {HeightMapProbe.Probes}");

		PackedScene marker = GD.Load<PackedScene>("res://test/marker.tscn");
		foreach (TerrainChunk chunk in chunks)
		{
			/*Node2D newMarker = marker.Instantiate<Node2D>();
			newMarker.Position = chunk.Position * 64;
			AddChild(newMarker);
			ArrayHelper.Print2DArray(chunk.probes);*/
			chunk.GenerateTerrain();
			foreach (HeightMapProbe probe in chunk.Probes)
			{
				if (probe.IsCorner)
				{
					Vector2I probePos = chunk.Position * 16 + probe.Position;
					Node2D newMarker = marker.Instantiate<Node2D>();
					newMarker.Position = probePos * 4;
					newMarker.Name = probePos.ToString();
					//GD.Print($"probe {newMarker.Name} of type {probe.CheckType()} at {probe.Position} in chunk {chunk.Position}");
					AddChild(newMarker);
				}
			}
		}

		// Print how long the process took
		ulong endTime = Time.GetTicksUsec();
		GD.Print($"Time elapsed:\n{endTime-startTime} microseconds");
		GD.Print($"{Math.Round((endTime-startTime) / 100.0) / 10} milliseconds");
		GD.Print($"{Math.Round(Math.Round((endTime-startTime) / 1000.0) / 100) / 10} seconds");
		GD.Print();
		//ArrayHelper.Print2DArray(ArrayHelper.Slice2DArray(Data.HeightMap, 0, 15, 0, 15));
		//ArrayHelper.Print2DArray(Data.HeightMap);

		// just generates the texture the sprite2d uses
		if (Debug)
		{
			Image img = new Image();
			byte[] imgData = ArrayHelper.Flatten2DArray(Data.HeightMap); // Flattens the heightmap
			img.SetData(Data.MapSize.X, Data.MapSize.Y, false, Image.Format.R8, imgData);
			// prints the whole heightmap
			
			/*byte[] imgData = new byte[chunks[0, 0].LocalHeightMap.Length];
			// Flattens the heightmap
			Buffer.BlockCopy(chunks[0, 0].LocalHeightMap, 0, imgData, 0, chunks[0, 0].LocalHeightMap.Length);
			img.SetData(16, 16, false, Image.Format.R8, imgData);
			// prints the chunk at (0, 0)*/

			//GD.Print(Data.HeightMap.Length);
			img.SavePng("res://test/map.png");
			DebugParent.GetNode<Sprite2D>("map").Texture = ImageTexture.CreateFromImage(img);
			//GetNode<Sprite2D>("%map").Texture = ImageTexture.CreateFromImage(img);
		}
	}
}
