using Godot;
using System;

/// <summary>
/// Used to find terrain corners.
/// </summary>
public partial class ChunkCorner : Resource
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
	protected enum HelperType
	{
		Flat,
		Corner,
		Edge,
		EdgeDiagonal,
		Edgecorner // has one straight edge and a corner (three levels), might be redundant/just use corner
	}

	public ChunkMeshHelper[] Neighbors = new ChunkMeshHelper[8];
	public ChunkMeshHelper[] Connections = new ChunkMeshHelper[8];
	public byte[] TileHeights = new byte[4];
	//public byte[] ExtendedHeightmap;
	//public Vector2I Position;
	public HelperType Type;

	/// <summary>
	/// Connects the target helper to this helper.
	/// Connects this helper to the target helper as well.
	/// </summary>
	/// <param name="toConnect">The ChunkMeshHelper to connect to.</param>
	/// <param name="connectDir">The direction to connect in.</param>
	public void ConnectHelper(ChunkMeshHelper toConnect, byte connectDir, bool setNeighbors = false)
	{
		Connections[connectDir] = toConnect;
		if (toConnect != null)
		{
			toConnect.Connections[connectDir + 4 % 8] = this;
		}

		// If set neighbors is set to true, allow overwriting the neighbors arr too. Used during setup.
		if (setNeighbors)
		{
			Neighbors[connectDir] = toConnect;
			if (toConnect != null) // Will occasionally be null on the edge of the map.
			{
				toConnect.Connections[connectDir + 4 % 8] = this;
			}
		}
	}

	// Disconnects this helper from its connections, and overwrites those connections with this neighbors previous connections
	public void DisconnectHelper(bool fullDisconnect = false)
	{
		for (int connection = 0; connection < Connections.Length(); connection++)
		{
			// Get the connected node in each direction
			// Then set what should be connected to this to what is connected to this in that same direction
			ChunkMeshHelper connected = Connections[connection];
			connected.Connections[connection + 4 % 8] = Connections[connection + 4 % 8];

			/* Technically safer but this shouldn't ever be needed, keeping for future reference:
			for (int findThis = 0; findThis < connection.Connections.Length(); findThis++)
			{
				if (connected.Connections[findThis] == this)
				{
					connected.Connections[findThis] = Connections[findThis];
					break;
				}
			}
			*/
		}

		if (fullDisconnect)
		{
			for (int connection = 0; connection < Connections.Length(); connection++)
			{
				// Get the connected node in each direction
				// Then set what should be connected to this to what is connected to this in that same direction
				ChunkMeshHelper connected = Neighbors[connection];
				connected.Neighbors[connection + 4 % 8] = null;
			}

			QueueFree();
		}
	}

	public void Setup()
	{
		Type = GetType(true);
		if (Type != HelperType.Corner)
		{
			DisconnectHelper();
		}
	}

	/*
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

		for (int tile = 0; tile < TileHeights.Length; tile++)
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
		for (byte connected = 0; connected < Connections.Length; connected++)
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
	}*/


	/// <summary>
	/// Check if this helper is an edge (not a corner) or if it is in a flat space and still does not need to be kept.
	/// </summary>
	/// <param name="level">int level, (may not be used)</param>
	/// <param name="recursive"></param>
	/// <returns>What type the helper is from the HelperType enum.</returns>
	public HelperType GetType(bool recursive = false)
	{
		// Runs if the tile is completely flat
		if (TileHeights[0] == TileHeights[1] &&
		TileHeights[1] == TileHeights[2] &&
		TileHeights[2] == TileHeights[3] &&
		TileHeights[3] == TileHeights[0])
		{
			return HelperType.Flat;
		}

		// First check if this contains any corners
		for (int tile = 0; tile < TileHeights.Length; tile++)
		{
			// If the other three tiles are all equal and the first is not, then it is a corner
			if (TileHeights[tile % 4] != TileHeights[tile + 1 % 4] &&
			TileHeights[tile + 1 % 4] == TileHeights[tile + 2 % 4] &&
			TileHeights[tile + 2 % 4] == TileHeights[tile + 3 % 4])
			{
				if (recursive)
				{
					for (int neighbor = 0; neighbor < 2; neighbor++)
					{
						// if either connection is just null, keep as a corner
						//Connections[(tile + 2) * 2].GetType(); // if either of these result in an edge
						//Connections[(tile + 3) * 2].GetType(); // then keep this as a corner
						if (Connections[(tile + 2) * 2].GetType() == HelperType.Edge ||
						Connections[(tile + 3) * 2].GetType() == HelperType.Edge)
						{
							return HelperType.Corner;
						}
					}
				}
				else
				{
					return HelperType.EdgeDiagonal;
				}
			}
		}

		// Check if we are an edge or need to be changed into a corner

		return HelperType.Corner;
	}


	/*public bool IsCorner(bool recursive = false)
	{
		bool isCorner = false;

		for (int tile = 0; tile < TileHeights.Length; tile++)
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
	}*/
}