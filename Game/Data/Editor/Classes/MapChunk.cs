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

	[Export]
	public TerrainChunkNode[] ChunkNodes = new TerrainChunkNode[289];

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
				TerrainChunkNode newCorner = new TerrainChunkNode();
				//Vector2I newCornerPos = new Vector2I(x, y);
				newCorner.Position = new Vector2I(x, y);

				// Pass the heightmap to the corner
				for (byte tile = 0; tile < newCorner.TileHeights.Length; tile++)
				{
					// Check if it is on the edge of the chunk
					Vector2 tileRelPos = new Vector2(x + (((tile % 2) - 0.5f) * 2),
						y + ((float)(Math.Floor(tile / 2f) - 0.5f) * 2)
					);
					newCorner.TileHeights[tile] = GetHeightAtPos((Vector2I)tileRelPos);
				}


				// Connect the current corner to any already existing corners
				foreach (TerrainChunkNode corner in ChunkNodes)
				{
					if (x - 1 <= corner.Position.X &&
						x + 1 >= corner.Position.X &&
						y + 1 >= corner.Position.Y &&
						y - 1 <= corner.Position.Y)
					{
						Vector2I relPos = new Vector2I(0, 0);
						relPos.X = x - corner.Position.X;
						relPos.Y = y - corner.Position.Y;

						// Find the direction
						//Print(relPos.ToString());
						//Print(((Vector2)relPos).Angle() / Math.PI * 4);
						//Print((((Vector2)newCornerPos).AngleTo((Vector2)child.Position) * 4).ToString());
						newCorner.ConnectHelper(corner, (byte)Math.Floor(((Vector2)relPos).Angle() / Math.PI * 4));
					}
				}

				//AddChild(newCorner);
				ChunkNodes[x + (y * 17)] = newCorner;
			}
		}
		Print();
	}


	// Input a tile position, output the height that is at that position
	public byte? GetHeightAtPos(Vector2I tilePos)
	{
		if (tilePos.X < 0 || tilePos.Y > 16)
		{
			return null;
		}
		if (tilePos.Y < 0 || tilePos.Y > 16)
		{
			return null;
		}

		return (byte)(tilePos.X + (tilePos.Y * 16));
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



	public void DeleteTerrainCorner(TerrainChunkNode corner)
	{
		ChunkNodes[Array.IndexOf(ChunkNodes, corner)] = null;
	}


	public void GenerateMesh()
	{
		/* // Prepare to generate the mesh
		foreach (TerrainChunkNode node in ChunkNodes)
		{
			node.Setup();
		} */

		// Get what node we are starting with
		TerrainChunkNode initialNode = null;
		foreach (TerrainChunkNode node in ChunkNodes)
		{
			if (node.GetType(true) == TerrainChunkNode.HelperType.Corner)
			{
				initialNode = node;
				break;
			}
		}

		if (initialNode == null)
		{
			GD.PushWarning("Could not find an initial node");
			return;
		}

		// Draw a wireframe for debug purposes
		// TODO: Change this later to be changed during runtime
		// So that I can see the full mesh AND wireframe
		Viewport currentViewport = GetViewport();
		currentViewport.DebugDraw = Viewport.DebugDrawEnum.Wireframe;

		/*
		TerrainChunkNode secondaryNode = null;
		TerrainChunkNode tertiaryNode = null;
		foreach (TerrainChunkNode secondaryConnection in initialNode.Connections)
		{
			foreach (TerrainChunkNode tertiaryConnection in secondaryConnection.Connections)
			{
				if (Array.Exists(tertiaryConnection.Connections, element => element == initialNode))
				{
					// Triangle Found
					// We need a region made of lines, not a triangle
				}
			}
		}
		*/
	}


	// TODO: this function
	// Returns an array containing arrays of regions
	// Each region is closed and SHOULD NOT overlap
	// Nodes can be shared between arrays
	// But they should not connect to each other through other regions
	// Additionally, avoid returning triangles.
	// Return the full regions that need to be triangulated.
	protected TerrainChunkNode[][] generateConstrainedEdges(TerrainChunkNode startingNode)
	{
		// used to get the direction in which we are travelling
		// in which to find the next corner
		// it is important to make sure that the height of every "flat" node inside is the same
		// i.e every edge node's "inner" side (current dir + 2)
		// is the same height
		byte currentDir = 0; // 0-7 range, try 0-3 * 2 for now (val % 4 * 2 or val * 2 % 8)
		byte insideDir = 0; // 0-3 range, used to check the "inner" shared tile

		return [];
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
