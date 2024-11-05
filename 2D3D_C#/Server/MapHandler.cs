using Godot;
using Godot.NativeInterop;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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
		EraseMissingCells();

		for (int layerLevel = 1; layerLevel <= mapLayers.Count; layerLevel++)
		{
			MapLayer layer = GetNode<MapLayer>("Layer" + layerLevel.ToString());
			if (mapSize.X < layer.GetUsedRect().Size.X + layer.GetUsedRect().Position.X)
			{
				mapSize.X = layer.GetUsedRect().Size.X + layer.GetUsedRect().Position.X;
			}
			if (mapSize.Y < layer.GetUsedRect().Size.Y + layer.GetUsedRect().Position.Y)
			{
				mapSize.Y = layer.GetUsedRect().Size.Y + layer.GetUsedRect().Position.Y;
			}
			GD.Print(mapSize);
			

			/* TODO */
			/*
			make a region out of tiles, send the region to layers above and below
			for bottom layer, check for entirely missing tiles and make a region there too, send that to bottom layer
			send each region to the highest layer
			for each layer's new regions, combine all of them where possible to prevent overlap
			
			yeah this'll be easy I definitely know how to make regions in the first place
			*/
		}

		Godot.Collections.Array<Vector2I> uncheckedTiles = new Godot.Collections.Array<Vector2I>();
		Godot.Collections.Array<Vector2I> toCheckTiles = new Godot.Collections.Array<Vector2I>();
		Godot.Collections.Array<Vector2I> checkedTiles= new Godot.Collections.Array<Vector2I>();

		for (int x = 0; x < mapSize.X; x++)
		{
			for (int y = 0; y < mapSize.X; y++)
			{
				
			}
		}


		GD.Print();
		GD.Print("LOADING DONE");
		GD.Print();
	}

	public void EraseMissingCells()
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
