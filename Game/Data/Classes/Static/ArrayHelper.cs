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
}
