extends Node

var player_position: Vector2 = Vector2.ZERO
const save_location = "user://SaveFile4.json"

var contents : Dictionary = {
	"player_exp": 0,
	"player_position_x" : -523,
	"player_position_y" : -93,
	"luckyloginteract" : "true"
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents.duplicate())
	file.close()

func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents.player_exp = save_data.player_exp
		contents.player_position_x = save_data.player_position_x
		contents.player_position_y = save_data.player_position_y
		contents.luckyloginteract = save_data.luckyloginteract
