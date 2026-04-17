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

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		if (Data is null) // If there is no map data, generate a new one.
		{
			Data = MapData.NewMap(new Vector2I(16, 16), 4, ChunkSize);
		}
		
		Vector2I size = Data.MapSize;
		Vector2I chunkMapSize = size / ChunkSize;
		chunks = new TerrainChunk[chunkMapSize.X, chunkMapSize.Y];
		// Create chunks
		for (uint chunkX = 0; chunkX < chunks.GetLength(0); chunkX++)
		{
			for (uint chunkY = 0; chunkY < chunks.GetLength(1); chunkY++)
			{
				TerrainChunk newChunk = TerrainChunk.NewChunk(
					new Vector2I((int)chunkX, (int)chunkY),
					ArrayHelper.Slice2DArray<byte>(Data.HeightMap, (int)chunkX * ChunkSize, ChunkSize, (int)chunkY * ChunkSize, ChunkSize)
				);
				//newChunk.Position = new Vector2I((int)chunkX, (int)chunkY);
				chunks[chunkX, chunkY] = newChunk; // Store the new chunk in the Chunk Array

				newChunk.quickie();
			}
		}
		//ArrayHelper.Print2DArray(Data.HeightMap);

		// just generates the texture the sprite2d uses
		if (Debug)
		{
			Image img = new Image();
			byte[] imgData = new byte[Data.HeightMap.Length];
			Buffer.BlockCopy(Data.HeightMap, 0, imgData, 0, Data.HeightMap.Length); // Flattens the heightmap
			img.SetData(Data.MapSize.X, Data.MapSize.Y, false, Image.Format.R8, imgData);
			// prints the whole heightmap
			
			/*byte[] imgData = new byte[chunks[0, 0].LocalHeightMap.Length];
			Buffer.BlockCopy(chunks[0, 0].LocalHeightMap, 0, imgData, 0, chunks[0, 0].LocalHeightMap.Length); // Flattens the heightmap
			img.SetData(16, 16, false, Image.Format.R8, imgData);
			// prints the chunk at (0, 0)*/

			//GD.Print(Data.HeightMap.Length);
			img.SavePng("res://test/map.png");
			DebugParent.GetNode<Sprite2D>("map").Texture = ImageTexture.CreateFromImage(img);
			//GetNode<Sprite2D>("%map").Texture = ImageTexture.CreateFromImage(img);
		}
	}
}
