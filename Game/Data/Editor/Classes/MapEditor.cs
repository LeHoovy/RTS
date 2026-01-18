using Godot;
using System;

[GlobalClass]
public partial class MapEditor : Node3D
{
	[Export]
	public String EditorMapsLocation = "res://Game/Data/Editor/Maps/";

	public override void _Ready()
	{
		MapEditor.CreateNewDialogueWindow(NewMapDialogue, this);
	}

	protected PackedScene NewMapDialogue = GD.Load<PackedScene>("uid://bko3lfheh3efu");
	/// <summary>
	/// This function generates a new popup window containing a dialogue to create a new map.
	/// 
	/// TODO: CreateNewDialogueWindow()
	/// Probably doesn't need to be in the MapEditor class, might work better in the dialogue's own class or a window management class
	/// [ ] Move this to a better fitting class
	/// </summary>
	/// <param name="newDialogue">The scene containing the dialogue to be loaded in the new window.</param>
	/// <param name="rootNode">Must exist within the current scene. If it doesn't exist, the script will fail. Can be any node as long as it exists.</param>
	/// <param name="winWidth">Sets the dialogue window's width. Set to 500 by default.</param>
	/// <param name="winHeight">Sets the dialogue window's height. Set to 720 by default.</param>
	public static void CreateNewDialogueWindow(PackedScene newDialogue, Node rootNode, int winWidth = 500, int winHeight = 720)
	{
		// Used repeatedly within the function
		Vector2I winSize = new Vector2I(winWidth, winHeight); // Used for the size of new windows

		// Used to find the position for the new map creation dialogue
		Window windowPosFinder = new Window();
		windowPosFinder.InitialPosition = Window.WindowInitialPosition.CenterOtherScreen;
		windowPosFinder.Size = winSize;
		rootNode.AddChild(windowPosFinder);

		// Save the position and delete the window used to find the position
		Vector2I newWinPos = windowPosFinder.Position;
		windowPosFinder.QueueFree();

		// Create the window for the new dialogue
		Window createMapWindow = new Window();
		rootNode.AddChild(createMapWindow);
		createMapWindow.Popup(new Rect2I(newWinPos, winSize));
		createMapWindow.CloseRequested += () => createMapWindow.QueueFree(); // Close the window when the X button is pressed

		// Generate the dialogue scene within the window
		createMapWindow.AddChild(newDialogue.Instantiate());
	}
}
