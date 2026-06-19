using Godot;
using System;
using System.Collections.Immutable;

public struct GridHelper
{
	private static readonly Vector2I _upLeft = new Vector2I(-1, -1);

	private static readonly Vector2I _upRight = new Vector2I(1, -1);

	private static readonly Vector2I _downLeft = new Vector2I(-1, 1);

	private static readonly Vector2I _downRight = new Vector2I(1, 1);

	private static readonly Vector2I[] _directionalTileNeighbors =
	[
		Vector2I.Right,			// LINEAR +
		DownRight,		// CORNER X
		Vector2I.Down,			// LINEAR +
		DownLeft,		// CORNER X
		Vector2I.Left,			// LINEAR +
		UpLeft,			// CORNER X
		Vector2I.Up,			// LINEAR +
		UpRight,		// CORNER X
	];

	//
	// Summary:
	//     Northwestern unit vector. Represents the direction of up and left.
	//
	// Value:
	//     Equivalent to new Vector2I(-1, -1).
	public static Vector2I UpLeft => _upLeft;

	//
	// Summary:
	//     Northeastern unit vector. Represents the direction of up and right.
	//
	// Value:
	//     Equivalent to new Vector2I(1, -1).
	public static Vector2I UpRight => _upRight;

	//
	// Summary:
	//     Southwestern unit vector. Represents the direction of down and left.
	//
	// Value:
	//     Equivalent to new Vector2I(-1, 1).
	public static Vector2I DownLeft => _downLeft;

	//
	// Summary:
	//     Southeastern unit vector. Represents the direction of down and right.
	//
	// Value:
	//     Equivalent to new Vector2I(1, 1).
	public static Vector2I DownRight => _downRight;


	//
	// Summary:
	//     An array containing each neighbor of a tile Vector2I(0, 0), in a directional clockwise format with 0 being Vector2I.Right, and 7 being GridHelper.UpRight.
	//
	// Value:
	//     An array of length 8 beginning at Vector2I(1, 0) and ending at Vector2I(1, -1), rotating clockwise around Vector2I(0, 0).
	public static Vector2I[] DirNeighborTiles => _directionalTileNeighbors;


	/// <summary>
	/// Creates an array like DirNeighborTiles but around a central tile instead of Vector2I(0, 0).
	/// </summary>
	/// <param name="tile">The central tile.</param>
	/// <returns>An array of length 8 beginning at Vector2I(Tile.X + 1, Tile.Y) and ending at Vector2I(Tile.X + 1, Tile.Y + 1), travelling clockwise around Tile.</returns>
	public static Vector2I[] TileNeighbors(Vector2I tile)
	{
		Vector2I[] output = new Vector2I[8];
		for (byte i = 0; i < 8; i++)
		{
			output[i] = GridHelper.DirNeighborTiles[i] + tile;
		}
		return output;
	}
}
