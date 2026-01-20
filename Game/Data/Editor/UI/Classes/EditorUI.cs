using Godot;
using System;

public partial class EditorUI : Control
{
	// Map file interaction buttons
	protected Button Save; // Saves map. Will open a dialogue to name and place the map if this has not already been done for the active map.
	protected Button Load; // Loads and opens a map for editing. Must be the editor file.
	protected Button NewMapButton; 
	/*
	Save button: 
		When clicked, the current map iteration will be saved.
		If the open map has not been previously saved, open a dialogue to pick where to store the map, and name the map if not previously named.
		TODO: Basically all of that
	Load button:
		When clicked, open a dialogue to load a new map.
		Warn the user if the current map has not yet been saved after any changes have been made.
		TODO: Basically all of that
	New button:
		Create a dialogue for creating a new map.
		Load the new map.
		TODO: Spawn the dialogue, make it create and load the new map.
		TODO: Rewrite the dialogue in C#.
	*/
	

	public override void _Ready()
	{
		// On editor load, make sure that the folders for map storage exists
		if (!DirAccess.DirExistsAbsolute(Map.FilePath)) // Check that it exists
		{
			GD.Print("Maps folder does not exist. Creating folder"); // Maps folder doesn't exist, continuing

			Error createMapsFolder = DirAccess.MakeDirRecursiveAbsolute(Map.FilePath); // Make the folders, store the error result
			if (createMapsFolder != Error.Ok) // Map wasn't successfully created, create an error
			{
				GD.PrintErr("Failed to create maps folder: ", createMapsFolder.ToString());
				GD.PushError("Editor map folder creation failure: ", createMapsFolder.ToString());
			}
			else
			{
				GD.Print("Successfully created maps folder");
			}

			GD.Print();
		}

		// Connect the "New" button to the window manager, creating a dialogue for creating a new map
		NewMapButton = GetNode<Button>("%New");
		NewMapButton.Pressed += () =>
		{
			WindowManager.CreateNewDialogueWindow(GD.Load<PackedScene>("uid://bko3lfheh3efu"), new Vector2I(500, 720));
		};
	}
}
