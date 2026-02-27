extends CharacterBody2D

const speed = 75
var current_dir = "none"

func _ready():
	if SaveLoad.contents.player_position_x != 0 and SaveLoad.contents.player_position_y != 0: # Check if a position was actually saved
		global_position.x = SaveLoad.contents.player_position_x
		global_position.y = SaveLoad.contents.player_position_y
	$AnimatedSprite2D.play("front_idle")

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Game is closing!")
		SaveLoad._save()
		get_tree().quit()

func _process(_delta):
	SaveLoad.contents.player_position_x = global_position.x
	SaveLoad.contents.player_position_y = global_position.y
	var direction : Vector2 = Vector2.ZERO
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	velocity = direction.normalized() * speed

func player():
	pass

func _physics_process(delta):
	move_and_slide()
	player_movement(delta)

func player_movement(_delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_animation("1")
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_animation("1")
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_animation("1")
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_animation("1")
	else:
		play_animation("0")

func play_animation(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == "1":
			anim.play("side_walk")
		elif movement == "0":
			anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == "1":
			anim.play("side_walk")
		elif movement == "0":
			anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == "1":
			anim.play("front_walk")
		elif movement == "0":
			anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == "1":
			anim.play("back_walk")
		elif movement == "0":
			anim.play("back_idle")
