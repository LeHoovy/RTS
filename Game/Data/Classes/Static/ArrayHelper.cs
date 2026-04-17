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
		for (int x = 0; x < arr.GetLength(0); x++)
		{
			string row = "";
			for (int y = 0; y < arr.GetLength(1); y++)
			{
				string newItem = arr[x, y].ToString();
				string end = "";
				if (y != arr.GetLength(1) - 1)// || y != arr.GetLength(1) - 1)
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
}
