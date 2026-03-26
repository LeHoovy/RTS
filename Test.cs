using Godot;
using Games.Indiegesindel;
using System;
using System.Threading.Tasks;

public partial class Test : Node3D
{
	private Steam _steamInstance;

	// Called when the node enters the scene tree for the first time.
	public override async void _Ready()
	{
		_steamInstance = Steam.GetSingleton();

		if (_steamInstance == null)
		{
			GD.PrintErr("Steam is not running! Quitting!");
			//GetTree().Quit();
			return;
		}

		_steamInstance.SteamInit(480, false);
		/*GD.Print("Steam is running! You are:");
		//	ulong userID = Steam.GetSteamID();
		GD.Print(_steamInstance.GetPersonaName());*/

		var name = _steamInstance.GetPersonaName();
		var state = _steamInstance.GetPersonaState();
		GD.Print($"Persona: {name} ({state})");
		GD.Print($"Account level: {_steamInstance.GetPlayerSteamLevel()}");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
