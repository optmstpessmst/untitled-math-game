class_name moduleButton extends Button

func _linker():
	SaveLoad.contents.player_position = global_position
	SaveLoad._save()
	var module = "res://modules/" + self.text + "/main.tscn"
	get_tree().change_scene_to_file(module)
