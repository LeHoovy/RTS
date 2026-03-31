using Godot;
using Godot.Collections;
using Games.Indiegesindel;
using System;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

public partial class Test : Node3D
{
	private Steam _instance;
	private MapData testMapData;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// Non-Steam stuff
		ulong microStart = Time.GetTicksUsec();
		testMapData = MapData.NewMap(new Vector2I(2, 16), 1);
		ulong microEnd = Time.GetTicksUsec();
		GD.Print($"Time elapsed:\n{microEnd-microStart} microseconds\n{Math.Round((microEnd-microStart) / 100.0) / 10} milliseconds");
		GD.Print();

		Image img = new Image();
		img.SetData(32, 256, false, Image.Format.R8, testMapData.HeightMap);
		img.SavePng("res://test/map.png");
		Sprite2D newSprite = new Sprite2D();
		GetNode<Sprite2D>("%map").Texture = ImageTexture.CreateFromImage(img);

		// Steam Stuff
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
