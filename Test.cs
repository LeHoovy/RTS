using Godot;
using Godot.Collections;
using Games.Indiegesindel;
using System;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

public partial class Test : Node3D
{
	private Steam _instance;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Node testSpace = GetNode<Node3D>("%test3d");
		GD.Print(testSpace.Name);

		_instance = Steam.GetSingleton();

		if (_instance == null)
		{
			GD.PrintErr("Steam is not running! Quitting!");
			//GetTree().Quit();
			return;
		}

		Dictionary initStatus = _instance.SteamInitEx(0, true);
		if ((int)initStatus["status"] == 0)
		{
			GD.Print("Steam has correctly initialized.");
		} else if ((int)initStatus["status"] == 2)
		{
			GD.PrintErr("Cannot connect to steam! Steam likely is not running.");
		} else if ((int)initStatus["status"] == 3)
		{
			GD.PrintErr("Steam client is out of date! Please update.");
		} else if ((int)initStatus["status"] == 1)
		{
			GD.PrintErr("Steam has failed to initialize! Quitting!");
			//GetTree().Quit();
		}
		
		/*GD.Print("Steam is running! You are:");
		//	ulong userID = Steam.GetSteamID();
		GD.Print(_instance.GetPersonaName());*/

		var name = _instance.GetPersonaName();
		var state = _instance.GetPersonaState();
		GD.Print($"Persona: {name} ({state})");
		GD.Print($"Account level: {_instance.GetPlayerSteamLevel()}");
		GD.Print($"Game id: {_instance.CurrentAppId}");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
