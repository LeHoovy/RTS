using Godot;
using System;
using System.Collections.Generic;

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
	protected Vector2I Position;
	protected byte[] LocalHeightmap;
	protected int[] LocalHeightmapPositions;

	// TODO: this whole class
	// position vector2i
	// size and stuff
	// local heighmap
	// some math to figure out where a local heightmap piece is on global heightmap

	public static MapChunk CreateNewChunk(byte[] globalHeightmap, Vector2I newPos, Vector2I mapSize)
	{
		// Create the new chunk
		MapChunk newChunk = new MapChunk();
		newChunk.Position = newPos;
		List<byte> newLocalHeightmap = [];
		List<int> newLocalHeightmapPositions = [];
		

		// ------ Calculate the local heightmap ------
		int rowSkip = mapSize.X * 16 * newPos.Y; // Used to calculate the starting position
		int heightmapStart = newPos.X * 16 + rowSkip; // The position within the global heightmap array which the local heightmap begins
		int nextRow = mapSize.X - 16; // Used to find the next row on the local heightmap
		int currentTile = heightmapStart; // Used to find the current tile on the global heightmap

		// Repeat for each row that will be contained in the local heightmap
		for (int row = 0; row < 16; row++)
		{
			// Repeat for each item that will be contained in the local heightmap
			for (int tile = 0; tile < 16; tile++)
			{
				newLocalHeightmap.Add(globalHeightmap[currentTile]); // Add the height to the new local heightmap
				newLocalHeightmapPositions.Add(currentTile); // Add its global position nto the keeper
				currentTile++; // Next tile
			}
			
			currentTile += nextRow; // Next row
		}

		// Save the heightmap arrays to the new chunk
		newChunk.LocalHeightmap = newLocalHeightmap.ToArray();
		newChunk.LocalHeightmapPositions = newLocalHeightmapPositions.ToArray();

		// Finish
		return newChunk;
	}

	/// <summary>
	/// Replaces a neighboring chunk with a new neighboring MapChunk, and replaces it's corrosponding neighbor with this MapChunk.
	/// </summary>
	/// <param name="neighborDir">The direction that the neighbor is. 0-8 is right to northwest.</param>
	/// <param name="newNeighbor">The neighboring MapChunk to operate with.</param>
	[Obsolete("May actually be useless unless chunk corners end up being weird")]
	public void SetNeighbor(byte neighborDir, MapChunk newNeighbor)
	{
		NeighboringChunks[neighborDir] = newNeighbor;
		newNeighbor.NeighboringChunks[neighborDir + 4 % 8] = this;
	}
}
