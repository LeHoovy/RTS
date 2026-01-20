using Godot;
using System;

public partial class Map : Node
{
	public const string FilePath = "user://editor/maps";
	protected Vector2I MapSize;

	/// <summary>
	/// Returns the current "Map" node in the scene.
	/// </summary>
	public static Map GetMap()
	{
		// Gets the scene's root node. The "Root" node is the window the scene is contained in.
		Node sceneRoot = (Engine.GetMainLoop() as SceneTree).Root.GetChildren()[0];
		return sceneRoot.GetNode<Map>("%Map");
	}
	/* public static void Test()
	{
		Node sceneRoot = (Engine.GetMainLoop() as SceneTree).Root.GetChildren()[0];
		GD.Print(sceneRoot.GetNode("%Test").Name);
	} */
}
