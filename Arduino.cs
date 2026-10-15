using Godot; //Set up program
using System;
using System.IO.Ports;

public partial class Arduino : Node2D //Main body
{
	SerialPort serialPort; //Instantiate objects and variables
	RichTextLabel text;
	bool wheeled = true; //Is the robot's wheels on the ground?

	// Called when the node enters the scene tree for the first time.
	public override void _Ready() //Set up serial port
	{
		text = GetNode<RichTextLabel>("DEBUG");
		serialPort = new SerialPort();
		serialPort.PortName = "COM3"; //The same in Arduino as it is in Godot.
		serialPort.BaudRate = 1000000; //The same in Arduino as it is in Godot.
		serialPort.Open();
	}
	
	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta) //Communicate with the robot
	{
		if(!serialPort.IsOpen) return; //If serial port is not open, do nothing.
		
		//Control the robot's movement.
		if(wheeled){
			if(Input.IsActionPressed("up")){
				serialPort.Write("1"); //1 represents move up.
				text.Text = "up";
			}else if(Input.IsActionPressed("left")){
				serialPort.Write("2"); //2 represents move left sharply.
				text.Text = "left";
			}else if(Input.IsActionPressed("right")){
				serialPort.Write("3"); //3 represents move right sharply.
				text.Text = "right";
			}else if(Input.IsActionPressed("down")){
				serialPort.Write("4"); //4 represent move down straight.
				text.Text = "down";
			}else if(Input.IsActionPressed("space")){
				serialPort.Write("5"); //5 represents dismount.
				text.Text = "dismount";
				wheeled = false;
			}else{
				text.Text = "...";
			}
		}else{
			if(Input.IsActionPressed("enter")){
				serialPort.Write("6"); //6 represents mount.
				text.Text = "mount";
				wheeled = true;
			}
		}
	}
	
	//var GlobalStats = GD.Load<GDScript>("res://GlobalStats.gd");
		//var GlobalStatsNode = (GodotObject)GlobalStats.New();
		//ismoving = GlobalStatsNode.Get("moving").As<bool>();
}
