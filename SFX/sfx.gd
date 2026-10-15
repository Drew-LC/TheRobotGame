extends Control

func play_sound(sfx : String):
	get_node(sfx).play()
