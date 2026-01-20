using Godot;
using System;

public partial class NewMapDialogue : Panel
{
	// When the map is created, collected the details from these
	protected TextEdit MapNameInput;
	protected OptionButton MapWidthInput;
	protected OptionButton MapHeightInput;
	protected OptionButton MapInitialDepthInput;

	public override void _Ready()
	{
		// Setup nodes
		MapNameInput = GetNode<TextEdit>("%Map Name");
		MapWidthInput = GetNode<OptionButton>("%Width Option");
		MapHeightInput = GetNode<OptionButton>("%Height Option");
		MapInitialDepthInput = GetNode<OptionButton>("%Depth Option");

		// Close on cancel pressed
		GetNode<Button>("%Cancel").Pressed += () => GetParent().QueueFree();

		// Create the map on creation pressed
		GetNode<Button>("%Confirm").Pressed += () => CreateMap();
	}

	protected void CreateMap()
	{
		// Get the new map's data
		string mapName = MapNameInput.Text;
		int mapWidth = (MapWidthInput.Selected * 16) + 32;
		int mapHeight = (MapHeightInput.Selected * 16) + 32;
		int mapInitialDepth = MapInitialDepthInput.Selected;

		// Output the map settings for debug purposes
		GD.Print
		(
			"name: ", mapName,
			", width: ", mapWidth.ToString(),
			", height: ", mapHeight.ToString(),
			", depth: ", mapInitialDepth.ToString()
		);

		// Store the map data in a dictionary
		Godot.Collections.Dictionary<string, Variant> mapData = new Godot.Collections.Dictionary<string, Variant>()
		{
			{"Name", mapName},
			{
				"Size", new Godot.Collections.Dictionary<string, Variant>()
				{
					{"Width", mapWidth},
					{"Height", mapHeight}
				}
			},
		};

		// Store the map data as a json
		string mapDataJson = Json.Stringify(mapData, "\t");
		newHeightMap(new(mapWidth, mapHeight, mapInitialDepth));

		// Finish and delete the window
		GetParent().QueueFree();
	}

	/// <summary>
	/// Used for creating a new heightmap for use in loading the map.
	/// </summary>
	/// <param name="heightMapSize">X and Y are for the width and height, Z is for the depth.</param>
	/// <returns>Outputs a heightmap in array form.</returns>
	protected byte[] newHeightMap(Vector3I heightMapSize)
	{
		// Initializes an empty heightmap
		byte[] heightMap = new byte[heightMapSize.X * heightMapSize.Y];

		for (int pos = 0; pos < heightMap.Length; pos++)
		{
			heightMap[pos] = (byte)heightMapSize.Z;
		}

		return [];
	}
}
