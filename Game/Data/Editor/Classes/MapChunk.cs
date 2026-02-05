using Godot;
using static Godot.GD;
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
	protected Vector2I Position = new Vector2I(-1, -1);
	protected byte[] LocalHeightmap;
	protected int[] LocalHeightmapPositions;

	// TODO: this whole class
	// position vector2i
	// size and stuff
	// local heighmap
	// some math to figure out where a local heightmap piece is on global heightmap

	public override void _Ready()
	{
		base._Ready();

		// Cull if not initialized correctly (through CreateNewChunk())
		if (
			LocalHeightmap.Length <= 0 ||
			LocalHeightmapPositions.Length <= 0 ||
			Position == new Vector2I(-1, -1)
		   )
		{
			PrintErr("MapChunk not initialized correctly, freeing.");
			QueueFree();
		}

		Print("Chunk Pos: ");
		Print(Position.ToString());
		Print("Helpers Pos:");
		for (int y = 0; y <= 16; y++)
		{
			for (int x = 0; x <= 16; x++)
			{
				Print((new Vector2I(x, y)).ToString());

				// create chunk mesh helpers at this position
				// connect to any previous ones within |x-x|=1 and |y-y|=1
				ChunkMeshHelper newHelper = new ChunkMeshHelper();
				Vector2I newHelperPos = new Vector2I(x, y);
				newHelper.Position = new Vector2I(newHelperPos.X, newHelperPos.Y);

				foreach (ChunkMeshHelper child in GetChildren())
				{
					if
					(
						x - 1 <= child.Position.X &&
						x + 1 >= child.Position.X &&
						y + 1 >= child.Position.Y &&
						y - 1 <= child.Position.Y
					)
					{
						Vector2I relPos = new Vector2I(0, 0);
						relPos.X = newHelperPos.X - child.Position.X;
						relPos.Y = newHelperPos.Y - child.Position.Y;

						// Find the direction
						//Print(relPos.ToString());
						//Print(((Vector2)relPos).Angle() / Math.PI * 4);
						//Print((((Vector2)newHelperPos).AngleTo((Vector2)child.Position) * 4).ToString());
						newHelper.ConnectHelper(child, (byte)Math.Floor(((Vector2)relPos).Angle() / Math.PI * 4));
					}
				}

				AddChild(newHelper);
			}
		}
		Print();
	}

	public static MapChunk CreateNewChunk(byte[] globalHeightmap, Vector2I newPos, Vector2I mapSize)
	{
		// Create the new chunk
		MapChunk newChunk = new MapChunk();
		newChunk.Position = newPos;
		List<byte> newLocalHeightmap = new();
		List<int> newLocalHeightmapPositions = new();
		

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

	protected void CheckTriangle()
	{
		
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
