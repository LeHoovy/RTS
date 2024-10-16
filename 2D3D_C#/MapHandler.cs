using Godot;
using System;
using System.Linq;

[GlobalClass]
public partial class MapHandler : Node2D
{
	public Godot.Collections.Array<TileMapLayer> mapLayersArr;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		foreach (TileMapLayer child in GetChildren())
		{
			if (child is TileMapLayer)
			{
				mapLayersArr.Add(child);
			}
		}
		GD.Print(mapLayersArr);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
