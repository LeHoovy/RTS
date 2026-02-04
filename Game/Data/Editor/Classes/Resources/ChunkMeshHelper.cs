using Godot;
using System;

/// <summary>
/// Used to find terrain corners.
/// </summary>
public partial class ChunkMeshHelper : Node
{
	public enum ConnectionDir
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
	public enum Tile
	{
		Southeast,
		Southwest,
		Northwest,
		Northeast
	}

	public ChunkMeshHelper[] Neighbors = new ChunkMeshHelper[8];
	public ChunkMeshHelper[] Connections = new ChunkMeshHelper[8];
	public byte[] TileHeights = new byte[4];
	public byte[] ExtendedHeightmap;
	public Vector2I Position;

	/// <summary>
	/// Connects the target helper to this helper.
	/// Connects this helper to the target helper as well.
	/// </summary>
	/// <param name="toConnect">The ChunkMeshHelper to connect to.</param>
	/// <param name="connectDir">The direction to connect in.</param>
	public void ConnectHelper(ChunkMeshHelper toConnect, byte connectDir)
	{
		Connections[connectDir] = toConnect;
		toConnect.Connections[connectDir + 4 % 8] = this;
	}

	/// <summary>
	/// Check to see if this terrain corner finder should be kept or deleted.
	/// Only keep this node if there is at least one corner.
	/// Culls the node if it is not a corner.
	/// 
	/// TODO: If it is a corner, check if both connected neighbors are lines. If they are, keep this.
	/// Forms 90 degree corners
	/// TODO: If it is a line, check if either connected neighbor is a corner that stays.
	/// Should form 45 degree corners
	/// i.e something like this:
	/// XX XX -> \X XX		XXXX      \XXX
	/// #X XX -> #\  \X             #XXX -> #\XX
	///       ->        OR               ####      ####
	/// #X XX -> #\  \X
	/// ## ## -> ## ##
	/// (Dont forget that each node overlaps with its direct neighbors)
	/// </summary>
	public void CheckIfCorner(bool reconnectNeighbors = false)
	{
		bool isCorner = false; // Set to true if any edge case

		for (int tile = 0; tile < 4; tile++)
		{
			if ( // Only keep if the neighboring tiles of a tile are both not equal height
				TileHeights[tile + 1] == TileHeights[tile] &&
				TileHeights[tile + 3 % 4] == TileHeights[tile]
			   )
			{
				isCorner = true;
			}
		}

		// Close out of the function if this is a corner
		if (isCorner)
		{
			return;
		}

		// Only run when this node is not a corner
		// Re-connect each piece
		for (byte connected = 0; connected < 8; connected++)
		{
			if (Connections[connected] != null && Connections[connected + 4 % 8] != null)
			{
				Connections[connected].ConnectHelper
				(
					Connections[connected + 4 % 8], (byte)(connected + 4 % 8)
				);
			}
			else
			{
				Connections[connected].Connections[connected + 4 % 8] = null;
			}
		}

		//QueueFree(); // Cull this node.
	}


	/// <summary>
	/// Check if this helper is an edge (not a corner) or if it is in a flat space and still does not need to be kept.
	/// </summary>
	/// <param name="level"></param>
	/// <param name="recursive"></param>
	/// <returns></returns>
	public bool HelperIsRedundant(int level, bool recursive = false)
	{

		return false;
	}


	public bool IsCorner(bool recursive = false)
	{
		bool isCorner = false;

		for (int tile = 0; tile < 4; tile++)
		{
			if ( // Check if any tile is on its own.
				TileHeights[tile + 1 % 4] == TileHeights[tile] &&
				TileHeights[tile + 3 % 4] == TileHeights[tile]
			   )
			{
				isCorner = true;
			}
		}

		return false;
	}
}