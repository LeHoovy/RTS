using Godot;
using Godot.Collections;
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

		/* // Store the map data in a dictionary
		Dictionary<string, Variant> mapData = new Dictionary<string, Variant>()
		{
			{"Name", mapName},
			{
				"Size", new Dictionary<string, Variant>()
				{
					{"Width", mapWidth},
					{"Height", mapHeight}
				}
			},
		}; */

		// Create a new MapData resource, and put the map details into it
		MapData mapData = new MapData();
		mapData.Name = mapName;
		mapData.Size = new Vector2I(mapWidth, mapHeight);

		// Generate and store a heightmap in the MapData resource
		mapData.HeightMap = newHeightMap(new(mapWidth, mapHeight, mapInitialDepth));

		// Send the new map's data to the editor map and load it
		Map.GetMap().Load(mapData);

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
