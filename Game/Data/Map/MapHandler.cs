using Godot;
using System;
using System.ComponentModel;

[GlobalClass]
public partial class MapHandler : Node
{
	public MapData Data;
	private TerrainChunk[] chunks;

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
		if (Data is null)
		{
			ulong microStart = Time.GetTicksUsec();
			Data = MapData.NewMap(new Vector2I(16, 16), 4, ChunkSize);
			ulong microEnd = Time.GetTicksUsec();
			GD.Print($"Time elapsed:\n{microEnd-microStart} microseconds\n{Math.Round((microEnd-microStart) / 100.0) / 10} milliseconds");
			GD.Print();
			//Data = MapData.NewMap(new Vector2I(16, 16), 4, ChunkSize);
		}
		
		Vector2I size = Data.MapSize;
		Vector2I chunkMapSize = size / ChunkSize;
		chunks = new TerrainChunk[chunkMapSize.X * chunkMapSize.Y];
		// Create chunks
		for (uint chunk = 0; chunk < chunks.Length; chunk++)
		{
			TerrainChunk newChunk = new TerrainChunk();
			newChunk.Position = new Vector2I((int)chunk % chunkMapSize.X, (int)chunk / chunkMapSize.Y);
			//AddChild(newChunk);
			chunks[chunk] = newChunk;
		}

		if (Debug)
		{
			Image img = new Image();
			img.SetData(Data.MapSize.X, Data.MapSize.Y, false, Image.Format.R8, Data.HeightMap);
			img.SavePng("res://test/map.png");
			DebugParent.GetNode<Sprite2D>("map").Texture = ImageTexture.CreateFromImage(img);
			//GetNode<Sprite2D>("%map").Texture = ImageTexture.CreateFromImage(img);
		}
	}
}
