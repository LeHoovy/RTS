using Godot;
using System;

public partial class CameraDebug : Camera2D
{
	private bool pan = false; // If true, move the camera in the direction the mouse moves. Do not stop, speed is determined by the distance the mouse travels
	private bool isDragging = false;

	private Vector2 mousePrevPos;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Input.UseAccumulatedInput = false;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		Vector2 mouseCurPos = GetLocalMousePosition();
		if (isDragging)
		{
			Position -= mouseCurPos - mousePrevPos;
		}
		mousePrevPos = mouseCurPos;
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("CameraDrag"))
		{
			isDragging = true;
			//mousePrevPos = GetLocalMousePosition();
		}
		if (@event.IsActionReleased("CameraDrag"))
		{
			isDragging = false;
		}
		if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed)
		{
			Vector2 mousePreZoom = GetLocalMousePosition();
			switch (mouseEvent.ButtonIndex)
			{
				case MouseButton.WheelUp:
					Vector2 zoomIn = new Vector2(Zoom.X * (float)1.2, Zoom.Y * (float)1.2);
					Zoom = zoomIn;
					break;
				case MouseButton.WheelDown:
					Vector2 zoomOut = new Vector2(Zoom.X / (float)1.2, Zoom.Y / (float)1.2);
					Zoom = zoomOut;
					break;
			}

			if (!isDragging)
			{
				Position -= GetLocalMousePosition() - mousePreZoom;
			}
		}
	}
}
