using Godot;
using System;
using System.IO.Ports;

public partial class Map : Node2D
{
	SerialPort serialPort;
	Label text;
	bool hasHeardFromArduino = false;
	float timer;
	
	public override void _Ready(){
		text = GetNode<Label>("Label");
		serialPort = new SerialPort();
		serialPort.PortName = "/dev/cu.usbmodem101";
		serialPort.BaudRate = 1000000;
		serialPort.Open();
	}
	
	public override void _Process(double delta){
		if(!serialPort.IsOpen) return;
		
		string serialMessage = serialPort.ReadLine();
		
		if(serialMessage == "WAH"){
			text.Text = "AAAAAH";
			hasHeardFromArduino = true;
			timer = Time.GetTicksMsec();
		}
		
		// if(serialMessage == "yay"){
		// 	text.Text = "horrah!";
		// }else if(serialMessage == "WAH"){
		// 	text.Text = "oh no!";
		// }
		
		if(hasHeardFromArduino && Time.GetTicksMsec() - timer > 3000){
			text.Text = "TESTING";
			serialPort.Write("1");
			hasHeardFromArduino = false;
		}
	}
}
