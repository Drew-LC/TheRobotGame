extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_beginner_pressed() -> void:
	GlobalStats.difficulty = 0
	startnewround()

func _on_intermediate_pressed() -> void:
	GlobalStats.difficulty = 1
	startnewround()

func _on_skilled_pressed() -> void:
	GlobalStats.difficulty = 2
	startnewround()

func _on_expert_pressed() -> void:
	GlobalStats.difficulty = 3
	startnewround()

func startnewround() -> void:
	Sfx.play_sound("ButtonClick")
	$StartScreen.visible = true
	var tween = create_tween()
	tween.tween_property($StartScreen/Start, "modulate:a", 1, 0.5)
	await get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://Map.tscn")

func _on_beginner_mouse_entered() -> void:
	Sfx.play_sound("ButtonHover")

func _on_intermediate_mouse_entered() -> void:
	Sfx.play_sound("ButtonHover")

func _on_skilled_mouse_entered() -> void:
	Sfx.play_sound("ButtonHover")

func _on_expert_mouse_entered() -> void:
	Sfx.play_sound("ButtonHover")
