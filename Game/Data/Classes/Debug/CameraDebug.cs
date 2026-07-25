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
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (isDragging)
		{
			Position -= GetLocalMousePosition() - mousePrevPos;;
			mousePrevPos = GetLocalMousePosition();
		}
		//mousePrevPos = GetLocalMousePosition();
	}

	public override void _Input(InputEvent @event)
	{
		if (@event.IsActionPressed("CameraDrag"))
		{
			isDragging = true;
			mousePrevPos = GetLocalMousePosition();
		}
		if (@event.IsActionReleased("CameraDrag"))
		{
			isDragging = false;
		}
		if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed)
		{
			switch (mouseEvent.ButtonIndex)
			{
				case MouseButton.WheelUp:
					Vector2 zoomIn = new Vector2(Zoom.X * (float)1.2, Zoom.Y * (float)1.2);
					Zoom = zoomIn;
					//Position -= GetLocalMousePosition() - mousePrevPos;
					//mousePrevPos = GetLocalMousePosition();
					break;
				case MouseButton.WheelDown:
					Vector2 zoomOut = new Vector2(Zoom.X / (float)1.2, Zoom.Y / (float)1.2);
					Zoom = zoomOut;
					//Position -= GetLocalMousePosition() - mousePrevPos;
					//mousePrevPos = GetLocalMousePosition();
					break;
			}
		}
		if (@event is InputEventMouseMotion motion && isDragging)
		{
			GD.Print("~~~~~~~~~~~~~~~~");
			GD.PrintRich($"velocity (\"scaled\"): {motion.Velocity}\nscreen velocity (unscaled): {motion.ScreenVelocity}");
			GD.Print();
			Vector2 relScale = GetGlobalTransform().Scale;
			GD.PrintRich($"relscale: {relScale}\nvelocity (manual scaling attempt): {motion.Velocity / relScale / Zoom}");
			//Position -= GetLocalMousePosition() - mousePrevPos;
			GD.Print($"change in position: {GetLocalMousePosition() - mousePrevPos}");
			//mousePrevPos = GetLocalMousePosition();
		}
	}
}
