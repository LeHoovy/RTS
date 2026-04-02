using Godot;
using System;
using System.ComponentModel;

[GlobalClass]
public partial class MapHandler : Node
{
	public MapData Data;
	private TerrainChunk[] chunks;
	[ExportGroup("Debug")]
	[Export]
	public bool Debug;
	[Export]
	public Node debugParent;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		if (Data is null)
		{
			Data = MapData.NewMap(new Vector2I(16, 16), 4);
		}
		
		Vector2I size = Data.MapSize;
		Vector2I chunkMapSize = size / 16;
		chunks = new TerrainChunk[size.X / 16 * (size.Y / 16)];
		// Create chunks
		for (uint chunk = 0; chunk < (chunkMapSize.X * chunkMapSize.Y); chunk++)
		{
			TerrainChunk newChunk = new TerrainChunk();
			newChunk.Position = new Vector2I((int)chunk % chunkMapSize.X, (int)chunk / chunkMapSize.Y);
			AddChild(newChunk);
		}
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
