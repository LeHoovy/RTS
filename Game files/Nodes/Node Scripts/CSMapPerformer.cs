using Godot;

[GlobalClass]
public partial class CSMapPerformer : Node
{
	public GridMap parentMap;
	public override void _Ready()
	{
		parentMap = this.GetParentOrNull<GridMap>();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

	public static Godot.Collections.Array<Vector3I> NeighborsOfCell(Vector3I cell)
	{
		var neighborCellsVar = new Godot.Collections.Array<Vector3I>{
			new (cell.X + 1, cell.Y, cell.Z),
			new (cell.X + 1, cell.Y, cell.Z + 1),
			new (cell.X, cell.Y, cell.Z + 1),
			new (cell.X - 1, cell.Y, cell.Z + 1),
			new (cell.X - 1, cell.Y, cell.Z),
			new (cell.X - 1, cell.Y, cell.Z - 1),
			new (cell.X, cell.Y, cell.Z - 1),
			new (cell.X = 1, cell.Y, cell.Z - 1)
			};
		return neighborCellsVar;
	}

	public static Godot.Collections.Array<Vector3I> IsPathable(Godot.Collections.Array<Vector3I> usedCells)
	{
		foreach (Vector3I cell in usedCells)
		{
			if (cell.X < 5)
			{
				GD.Print("Cell X coordinate is less than 5");
			}
		}
		return usedCells;
	}
}
