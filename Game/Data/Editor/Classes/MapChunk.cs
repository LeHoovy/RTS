using Godot;
using System;

public partial class MapChunk : Node
{
	public enum Neighbor : byte
	{
		East,
		Southeast,
		South,
		Southwest,
		West,
		Northwest,
		North,
		Northeast
	}
	public MapChunk[] NeighboringChunks = new MapChunk[8];

	// TODO: this whole class
	// position vector2i
	// size and stuff
	// local heighmap
	// some math to figure out where a local heightmap piece is on global heightmap

	public static MapChunk CreateNewChunk(byte[] globalHeightmap)
	{
		return new MapChunk();
	}

	/// <summary>
	/// Replaces a neighboring chunk with a new neighboring MapChunk, and replaces it's corrosponding neighbor with this MapChunk.
	/// </summary>
	/// <param name="neighborDir">The direction that the neighbor is. 0-8 is right to northwest.</param>
	/// <param name="newNeighbor">The neighboring MapChunk to operate with.</param>
	public void SetNeighbor(byte neighborDir, MapChunk newNeighbor)
	{
		NeighboringChunks[neighborDir] = newNeighbor;
		newNeighbor.NeighboringChunks[neighborDir + 4 % 8] = this;
	}
}
