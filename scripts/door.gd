extends Area2D

@export var direct: String = ""

var player_in_range := false

func _on_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
		get_node("/root/%s" % direct).hide_dialog()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("E"):
		print("Player in door range.")
		show_message()
	elif Input.is_action_just_pressed("E"):
		print("Player not in door range.")

func show_message():
	get_node("/root/%s" % direct).show_text()
