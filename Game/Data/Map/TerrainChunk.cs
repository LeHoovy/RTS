using Godot;
using System;

public partial class TerrainChunk : Node
{
	public Vector2I Position; // Position relative to other chunks/to the map.
	public byte[] LocalHeightMap; // The heightmap that is contained on the chunk.

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GD.Print(Position);
		Name = $"Chunk{Position.X},{Position.Y}";
	}


	/// <summary>
	/// Converts a tile position into a heightmap position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Tile position we want to find the heightmap position of.</param>
	/// <returns>Heightmap position of the given tile.
	/// If the tile is not on the map, returns 0.</returns>
	private uint ConvertPos(Vector2I pos)
	{
		if (pos.X < 0 || pos.X >= 16)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}
		if (pos.Y < 0 || pos.Y >= 16)
		{
			GD.PrintErr($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			GD.PushError($"Could not find a tile at position ({pos.X}, {pos.Y})!");
			return 0;
		}

		return (uint)(pos.X + (pos.Y * 16));
	}


	/// <summary>
	/// Converts a heightmap position to a map position.<br/>
	/// Vice Versa for overload.
	/// </summary>
	/// <param name="pos">Position on the heightmap to convert to a map position.</param>
	/// <returns>Returns the tile position of the given heightmap position.
	/// Returns the (-1, -1) if the given position does not exist..</returns>
	private Vector2I ConvertPos(uint pos)
	{
		if (pos >= 256)
		{
			GD.PrintErr($"Position ''{pos}'' is out of range. Max range: {255}");
			GD.PushError($"Position ''{pos}'' is out of range. Max range: {255}");
			return new Vector2I(-1, -1);
		}

		return new Vector2I((int)pos % 16, (int)Math.Floor((double)pos / 16));
	}
}
