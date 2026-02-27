extends Area2D

@export_multiline var message: String = "The sign is blank."
@export var type_interact: String = "default"

var player_in_range := false

func _on_body_entered(body):
	if body.has_method("player"):
		player_in_range = true

func _on_body_exited(body):
	if body.has_method("player"):
		player_in_range = false
		dialog.hide_dialog()

func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("E"):
		SaveLoad._load()
		print("Player in sign range.")
		if type_interact == "well":
			SaveLoad.contents.player_exp -= 1
			SaveLoad._save()
			print(SaveLoad.contents.player_exp)
			show_message()
		elif type_interact == "luckylog":
			if SaveLoad.contents.luckyloginteract == "true":
				SaveLoad.contents.player_exp += 5
				SaveLoad.contents.luckyloginteract = "false"
				SaveLoad._save()
				print(SaveLoad.contents.player_exp)
				show_message()
		else:
			show_message()
	elif Input.is_action_just_pressed("E"):
		print("Player not in sign range.")

func show_message():
	dialog.show_text(message)
