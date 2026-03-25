extends Node

var player_position: Vector2 = Vector2.ZERO
const save_location = "user://SaveFile6.json"

var contents : Dictionary = {
	"player_exp": 0,
	"player_position_x" : -523,
	"player_position_y" : -93,
	"luckyloginteract" : "true",
	"factor_score": 0,
	"factor_total_questions": 0,
	"factor_a": 0,
	"factor_b": 0,
	"factor_question_text": "",
	"factor_correct_answer": "",
	"factor_product_type": "",
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
		contents.factor_score = save_data.factor_score
		contents.factor_total_questions = save_data.factor_total_questions
		contents.factor_a = save_data.factor_a
		contents.factor_b = save_data.factor_b
		contents.factor_question_text = save_data.factor_question_text
		contents.factor_correct_answer = save_data.factor_correct_answer
		contents.factor_product_type = save_data.factor_product_type
