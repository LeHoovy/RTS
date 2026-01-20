using Godot;
using System;

[GlobalClass]
public partial class WindowManager : Resource
{

	// [x] Move to a better fitting class
	/// <summary>
	/// This function generates a new popup window containing a dialogue to create a new map.
	/// </summary>
	/// <param name="newDialogue">The scene containing the dialogue to be loaded in the new window.</param>
	/// <param name="rootNode">Must exist within the current scene. If it doesn't exist, the script will fail. Can be any node as long as it exists.</param>
	/// <param name="winSize">The new window's size.</param>
	public static void CreateNewDialogueWindow(PackedScene newDialogue, Node rootNode, Vector2I winSize)
	{
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
