using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

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

		LoadMap();
		eraseMissingCells();
	}

	public void eraseMissingCells()
	{
		Godot.Collections.Array<Vector2I> cellsUsed = new Godot.Collections.Array<Vector2I>();
		foreach (MapLayer layer in mapLayers)
		{
			GD.Print("Checking Layer: ", layer.Name);
			foreach (Godot.Vector2I cell in layer.GetUsedCells())
			{
				if (cellsUsed.Contains(cell) || isBehindPosition(cell))
				{
					GD.Print("Cell ", cell, " already exists: ", cellsUsed.Contains(cell), ". Cell is behind (0, 0): ", isBehindPosition(cell));
					layer.EraseCell(cell);
					continue;
				}
				if (layer.GetCellAtlasCoords(cell) == new Vector2I(2, 0))
				{
					GD.Print("Cell ", cell, " was a bridge");
					continue;
				}
				cellsUsed.Add(cell);
			}
			GD.Print(cellsUsed);
			GD.Print();

		}
	}

	public bool isBehindPosition(Vector2I currentPosition, Vector2I targetPosition = default)
	{
		if (currentPosition.X < targetPosition.X || currentPosition.Y < targetPosition.Y)
		{
			return true;
		}
		return false;
	}

	public void LoadMap()
	{
		return;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
