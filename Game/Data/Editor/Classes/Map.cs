using Godot;
using System;

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
		return sceneRoot.GetNode<Map>("%Map");
	}

	public void Load(MapData newMap)
	{
		// Overwrite and erase the previously loaded map
		Data = newMap;
		foreach (Node child in GetChildren())
		{
			child.QueueFree();
		}

		// Create chunk child, with each chunk being 16x16
		// TODO: Create chunks and give them their data
	}
}
