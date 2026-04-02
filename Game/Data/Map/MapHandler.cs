using Godot;
using System;
using System.ComponentModel;

[GlobalClass]
public partial class MapHandler : Node
{
	public MapData Data;
	[ExportGroup("Debug")]
	[Export]
	public bool Debug;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
