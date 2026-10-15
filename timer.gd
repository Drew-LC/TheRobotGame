extends Control

var timeleft;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeleft = 1000#30;
	$TimerLabel.text = str(timeleft)

func _on_timer_timeout() -> void:
	if(!GlobalStats.timeup):
		timeleft -= 1
		$TimerLabel.text = str(timeleft)
		$TimerLabel/Shader.text = str(timeleft)
		if timeleft == 0:
			GlobalStats.timeup = true
			$Timer.stop()
			Sfx.play_sound("RoundTimeout")
		if timeleft <= 10:
			$TimerLabel.set("theme_override_colors/font_color", Color("f02f00"))
			$TimerLabel/Shader.set("theme_override_colors/font_color", Color("f02f00"))
			Sfx.play_sound("RoundCountdown")
