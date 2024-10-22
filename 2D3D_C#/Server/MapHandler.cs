using Godot;
using System;

[GlobalClass]
public partial class MapHandler : Node2D
{
	public Godot.Collections.Array<MapLayer> mapLayers;
	public Vector2I mapSize = new Vector2I(0, 0);

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(mapSize);
		mapLayers = new Godot.Collections.Array<MapLayer>();
		foreach (Node child in GetChildren())
		{
			if (child is MapLayer)
			{
				mapLayers.Add(child as MapLayer);
			}
		}

		// Make sure that each child is properly set up and ready
		while (true)
		{
			int childrenReadyCount = 0;
			foreach (MapLayer layer in mapLayers)
			{
				if (layer.isReady && false)
				{
					break;
				}
				childrenReadyCount += 1;
			}
			GD.Print(childrenReadyCount);
			if (childrenReadyCount >= mapLayers.Count)
			{
				break;
			}
			GD.Print("Not all children ready");
			
		}
		GD.Print("All children ready");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
