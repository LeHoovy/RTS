using Godot;
using System;

public static class ArrayHelper
{
	/// <summary>
	/// Slices a 2-Dimensional array.
	/// </summary>
	/// <typeparam name="T">What type of array is being sliced</typeparam>
	/// <param name="src">The array to slice.</param>
	/// <param name="startX">The starting X coordinate within the array.</param>
	/// <param name="width">How far from the starting X position to slice.</param>
	/// <param name="startY">The starting Y coordinate within the array.</param>
	/// <param name="height">How far from the starting Y position to slice.</param>
	/// <returns>A sliced array, from (startX to startX+width), (startY to startY+height)</returns>
	public static T[,] Slice2DArray<T>(T[,] src, int startX, int width, int startY, int height)
	{
		T[,] result = new T[width, height];
		for (int i = 0; i < width; i++)
		{
			for (int j = 0; j < height; j++)
			{
				result[i, j] = src[startX + i, startY + j];
			}
		}
		return result;
	}


	/// <summary>
	/// Prints a 2-dimensional arary to the godot console.
	/// </summary>
	/// <typeparam name="T">What type of array is being printed</typeparam>
	/// <param name="arr">The 2-dimensional array</param>
	public static void Print2DArray<T>(T[,] arr)
	{
		int len = 0;
		foreach (T item in arr)
		{
			var itemLen = item.ToString().Length;
			if (itemLen > len)
			{
				len = itemLen;
			}
		}

		GD.Print('[');
		for (int y = 0; y < arr.GetLength(1); y++)
		{
			string row = "";
			for (int x = 0; x < arr.GetLength(0); x++) // in y, x order to get rows instead of columns
			{
				string newItem = arr[x, y].ToString();
				string end = "";
				if (x != arr.GetLength(1) - 1)// || y != arr.GetLength(1) - 1)
				{
					end = ", ";
				}
				string exSpaces = ""; // extra spaces to make sure each item is the same size
				for (int space = 0; space < len - newItem.Length; space++)
				{
					exSpaces += " ";
				}

				row += exSpaces + newItem + end; // exSpaces on the left to be right-aligned
				//row += newItem + end + exSpaces; // exSpaces on the right to be left-aligned
			}
			GD.Print(row);
		}
		GD.Print(']');
	}


	/// <summary>
	/// Flattens a 2D array by creating a new array and each row to the end of the previous row.
	/// </summary>
	/// <typeparam name="T">The type of array that is being flattened.</typeparam>
	/// <param name="arr">The array being flattened. Must be 2D.</param>
	/// <returns>The flattened array.</returns>
	public static T[] Flatten2DArray<T>(T[,] arr)
	{
		Vector2I size = new Vector2I(arr.GetLength(0), arr.GetLength(1));
		T[] output = new T[size.X * size.Y];
		for (int j = 0; j < size.Y; j++) // Goes column by column
		{
			for (int i = 0; i < size.X; i++) // Adds each row to the end of the last
			{
				int curPos = i + (j * size.X);
				output[curPos] = arr[i, j];
			}
		}
		return output;
	}
}
