using Godot;
using Godot.Collections;
using Games.Indiegesindel;
using System;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

public partial class Test : Node3D
{
	private Steam instance;
	private MapData testMapData;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		// Non-Steam stuff
		ulong microStart = Time.GetTicksUsec();
		testMapData = MapData.NewMap(new Vector2I(32, 32), 1);
		ulong microEnd = Time.GetTicksUsec();
		GD.Print($"Time elapsed:\n{microEnd-microStart} microseconds\n{Math.Round((microEnd-microStart) / 100.0) / 10} milliseconds");
		GD.Print();

		// debug heightmap creation
		Image img = new Image();
		img.SetData(testMapData.MapSize.X, testMapData.MapSize.Y, false, Image.Format.R8, testMapData.HeightMap);
		img.SavePng("res://test/map.png");
		Sprite2D newSprite = new Sprite2D();
		GetNode<Sprite2D>("%map").Texture = ImageTexture.CreateFromImage(img);

		// Steam Stuff
		instance = Steam.GetSingleton();
		if (instance == null)
		{
			GD.PrintErr("Steam is not running! Quitting!");
			//GetTree().Quit();
			return;
		}

		Dictionary initStatus = instance.SteamInitEx(0, true);
		if ((int)initStatus["status"] == 0)
		{
			GD.Print("Steam has correctly initialized.");
		} else if ((int)initStatus["status"] == 2)
		{
			GD.PrintErr("Quitting: Cannot connect to steam! Steam likely is not running.");
			//GetTree().Quit();
			return;
		} else if ((int)initStatus["status"] == 3)
		{
			GD.PrintErr("Steam client is out of date! Please update.");
		} else if ((int)initStatus["status"] == 1)
		{
			//GD.PrintErr("Quitting: Steam has failed to initialize! Quitting!");
			//GetTree().Quit();
			return;
		}
		
		/*GD.Print("Steam is running! You are:");
		//	ulong userID = Steam.GetSteamID();
		GD.Print(instance.GetPersonaName());*/

		var name = instance.GetPersonaName();
		var state = instance.GetPersonaState();
		GD.Print($"Persona: {name} ({state})");
		GD.Print($"Account level: {instance.GetPlayerSteamLevel()}");
		GD.Print($"Game id: {instance.CurrentAppId}");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
