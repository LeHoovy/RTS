using Godot;
using System;

[GlobalClass]
public partial class MapEditor : Node3D
{
	[Export]
	public String EditorMapsLocation = "res://Game/Data/Editor/Maps/";

	public override void _Ready()
	{
		//WindowManager.CreateNewDialogueWindow(NewMapDialogue, this, new Vector2I(500, 720));
	}
	protected PackedScene NewMapDialogue = GD.Load<PackedScene>("uid://bko3lfheh3efu");
}
