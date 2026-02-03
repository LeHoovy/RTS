using Godot;
using System;

[GlobalClass]
public partial class Map : Node
{
	public const string FilePath = "user://editor/maps";
	public MapData Data;

	/// <summary>
	/// Returns the current "Map" node in the scene.
	/// </summary>
	public static Map GetMap()
	{
		// Gets the scene's root node. The "Root" node is the window the scene is contained in.
		Node sceneRoot = (Engine.GetMainLoop() as SceneTree).Root.GetChildren()[0];
		GD.Print(sceneRoot);
		return sceneRoot.GetNode("%Map") as Map;
	}

	public void Load(MapData newMap)
	{
		// Overwrite and erase the previously loaded map
		Data = newMap;
		foreach (Node chunk in GetTree().GetNodesInGroup("Map Chunks"))
		{
			chunk.RemoveFromGroup("Map Chunks");
			chunk.QueueFree();
		}

		// Create chunk child, with each chunk being 16x16
		// TODO: Create chunks and give them their data
		for (int y = 0; y < newMap.Size.X / 16; y++)
		{
			for (int x = 0; x < newMap.Size.Y / 16; x++)
			{
				MapChunk newChunk = MapChunk.CreateNewChunk(newMap.HeightMap, new Vector2I(x, y), newMap.Size);
				AddChild(newChunk);
				newChunk.AddToGroup("Map Chunks");
			}
		}
	}
}
