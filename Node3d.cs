using Godot;
using System;

public partial class Node3d : Node3D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Node nodeNone = GetNode<Node>("%test");
		Node3D nodeSpace = GetNode<Node3D>("%test3d");
		Node2D nodeFlat = GetNode<Node2D>("%test2d");
		GD.Print(nodeNone.Name);
		GD.Print(nodeFlat.Name);
		GD.Print(nodeSpace.Name);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
