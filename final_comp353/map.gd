extends Control

@export var movespeed : float = 3.8
@export var rotationspeed : float = 0.0074
@export var disappeartime : float = 5.0
@export var dismounting : bool = false
@export var dismounttime : float = 3.0
@export var distance : float
@export var sMax : float = 0.1
@export var aMax : float = 0.3
@export var bMax : float = 0.5
@export var cMax : float = 0.7
@export var dMax : float = 0.9
@export var eMax : float = 1.1
@export var once = true
@export var pixelsperinch = 141.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalStats.timeup = false
	GlobalStats.roundover = false
	$Goal.position.x = randf_range(69, 1210)
	$Goal.position.y = randf_range(69, 484)
	$Robot/DismountBar/DismountProgress.max_value = dismounttime
	$Robot/DismountBar/DismountProgress.step = dismounttime / 100
	Sfx.play_sound("RoundStart")
	await get_tree().create_timer(1.0).timeout
	$Go.visible = false
	GlobalStats.moving = true
	match GlobalStats.difficulty:
		1:
			await get_tree().create_timer(disappeartime).timeout
			var tween = create_tween()
			tween = create_tween()
			tween.tween_property($Goal, "modulate:a", 0, 0.5)
		2:
			await get_tree().create_timer(disappeartime).timeout
			var tween = create_tween()
			tween = create_tween()
			tween.tween_property($Robot, "modulate:a", 0, 0.5)
		3:
			await get_tree().create_timer(disappeartime).timeout
			var tween = create_tween()
			tween = create_tween()
			tween.set_parallel()
			tween.tween_property($Goal, "modulate:a", 0, 0.5)
			tween.tween_property($Robot, "modulate:a", 0, 0.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(dismounting):
		GlobalStats.moving = false
		$Robot/DismountBar.visible = true
		$Robot/DismountBar/DismountProgress.value = $Robot/DismountBar/DismountTimer.wait_time - $Robot/DismountBar/DismountTimer.time_left
		$Robot/DismountBar/DismountProgress.position = Vector2($Robot.position.x - 70, $Robot.position.y + 80)
		if $Robot/DismountBar/DismountProgress.value == $Robot/DismountBar/DismountProgress.max_value:
			dismounting = false
			await get_tree().create_timer(1.0).timeout
			GlobalStats.roundover = true
	if(GlobalStats.timeup):
		GlobalStats.moving = false
		$TimeUp.visible = true;
		await get_tree().create_timer(3.0).timeout
		GlobalStats.roundover = true;
	if(GlobalStats.roundover):
		distance = sqrt(pow($Robot.position.x - $Goal.position.x, 2) + pow($Robot.position.y - $Goal.position.y, 2))
		$EndScreen.visible = true;
		if Input.is_action_pressed("enter"):
			$EndScreen/Note.text = "3..."
			await get_tree().create_timer(1.0).timeout
			$EndScreen/Note.text = "2..."
			await get_tree().create_timer(1.0).timeout
			$EndScreen/Note.text = "1..."
			await get_tree().create_timer(1.0).timeout
			$EndScreen/Note.visible = false
			$EndScreen/QuitButton.visible = true

# Frame rate is synced to the physics. Delta is constant.
func _physics_process(_delta: float) -> void:
	if GlobalStats.moving:
		if Input.is_action_pressed("up"):
			$Robot.position -= $Robot.transform.y * movespeed
		elif Input.is_action_pressed("down"):
			$Robot.position += $Robot.transform.y * movespeed
		elif Input.is_action_pressed("left"):
			$Robot.rotation -= rotationspeed
		elif Input.is_action_pressed("right"):
			$Robot.rotation += rotationspeed
		elif Input.is_action_pressed("space"):
			dismounting = true
			$Robot/DismountBar/DismountTimer.start(dismounttime)
		if $Robot.position.y >= 720:
			$Robot.position.y = 0
		elif $Robot.position.y <= 0:
			$Robot.position.y = 720
		elif $Robot.position.x >= 1280:
			$Robot.position.x = 0
		elif $Robot.position.x <= 0:
			$Robot.position.x = 1280

func _on_end_screen_visibility_changed() -> void:
	Sfx.play_sound("RoundResult")
	$EndScreen/EndLabel1/DistanceTitle/DistanceLabel.text = str(snapped(distance / pixelsperinch, 0.001)) + " in."
	$EndScreen/EndLabel1/DistanceTitle/DistanceLabel/Shader.text = str(snapped(distance / pixelsperinch, 0.001)) + " in."
	if((distance/pixelsperinch) <= sMax):
		$EndScreen/EndLabel2.text = "S"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "5c5aff")
		$EndScreen/EndLabel2/Comment.text = "WOW!"
	elif((distance/pixelsperinch) <= aMax):
		$EndScreen/EndLabel2.text = "A"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "00f544")
		$EndScreen/EndLabel2/Comment.text = "Good job!"
	elif((distance/pixelsperinch) <= bMax):
		$EndScreen/EndLabel2.text = "B"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "00f544")
		$EndScreen/EndLabel2/Comment.text = "You can do even better!"
	elif((distance/pixelsperinch) <= cMax):
		$EndScreen/EndLabel2.text = "C"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "ffe658")
		$EndScreen/EndLabel2/Comment.text = "You can do better!"
	elif((distance/pixelsperinch) <= dMax):
		$EndScreen/EndLabel2.text = "D"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "ffe658")
		$EndScreen/EndLabel2/Comment.text = "Try again!"
	elif((distance/pixelsperinch) <= eMax):
		$EndScreen/EndLabel2.text = "E"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "b8573c")
		$EndScreen/EndLabel2/Comment.text = "Try again!"
	else:
		$EndScreen/EndLabel2.text = "F"
		$EndScreen/EndLabel2.set("theme_override_colors/font_color", "b8573c")
		$EndScreen/EndLabel2/Comment.text = "F for effort!"
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property($EndScreen/EndColor, "modulate:a", 1, 0.5)
	tween.tween_property($EndScreen/EndLabel1, "modulate:a", 1, 0.5)
	await get_tree().create_timer(1.5).timeout
	Sfx.play_sound("Grade")
	$EndScreen/EndLabel2.visible = true
	await get_tree().create_timer(1.0).timeout
	tween = create_tween()
	tween.tween_property($EndScreen/Note, "modulate:a", 1, 0.5)

func _on_quit_button_pressed() -> void:
	Sfx.play_sound("ButtonClick")
	get_tree().quit()

func _on_quit_button_mouse_entered() -> void:
	Sfx.play_sound("ButtonHover")
