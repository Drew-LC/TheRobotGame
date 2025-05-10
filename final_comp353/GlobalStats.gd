extends Node2D

var difficulty : int
var roundover : bool = false
var timeup : bool = false
var moving : bool = false:
	get:
		return moving
	set(value):
		moving = value
