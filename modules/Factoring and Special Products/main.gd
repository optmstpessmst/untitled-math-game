extends Control

# Node paths
@onready var score_label    = $MarginContainer/HBoxContainer/ScoreLabel
@onready var question_label = $MarginContainer/VBoxContainer/QuestionLabel
@onready var answer_input   = $MarginContainer/VBoxContainer/AnswerInput
@onready var submit_button  = $MarginContainer/VBoxContainer/HBoxContainer/SubmitButton
@onready var result_label   = $MarginContainer/VBoxContainer/ResultLabel
@onready var next_button    = $MarginContainer/VBoxContainer/NextQuestionButton

var product_type: int
var correct_answer: String
var a: int
var b: int

var score: int = 0
var total_questions: int = 0
const MAX_QUESTIONS: int = 15
var answered := false


func _ready():
	randomize()
	submit_button.pressed.connect(on_submit)
	next_button.pressed.connect(on_next_question)
	
	SaveLoad._load()

	score = SaveLoad.contents.factor_score
	total_questions = SaveLoad.contents.factor_total_questions
	
	if SaveLoad.contents.factor_question_text != "":
		# Restore previous question
		a = SaveLoad.contents.factor_a
		b = SaveLoad.contents.factor_b
		product_type = SaveLoad.contents.factor_product_type
		
		question_label.text = SaveLoad.contents.factor_question_text
		correct_answer = SaveLoad.contents.factor_correct_answer
	else:
		generate_problem()

	next_button.visible = false
	update_score_label()

func save_module_state():
	SaveLoad._load()

	SaveLoad.contents.factor_score = score
	SaveLoad.contents.factor_total_questions = total_questions
	SaveLoad.contents.factor_a = a
	SaveLoad.contents.factor_b = b
	SaveLoad.contents.factor_product_type = product_type
	SaveLoad.contents.factor_question_text = question_label.text
	SaveLoad.contents.factor_correct_answer = correct_answer
	
	SaveLoad._save()

# -------------------------
# Format coefficient nicely
# -------------------------
func format_term(coef: int, variable: String) -> String:
	if coef == 0:
		return ""
	elif coef == 1:
		return variable
	elif coef == -1:
		return "-" + variable
	else:
		return str(coef) + variable

func get_factors(expr: String) -> Array:
	var factors: Array = []
	var current := ""
	var depth := 0

	for c in expr:
		if c == "(":
			depth += 1
			current += c
		elif c == ")":
			current += c
			depth -= 1
			if depth == 0:
				factors.append(current)
				current = ""
		else:
			current += c

	# Handle squared form like (x+3)^2
	if "^2" in expr and factors.size() == 1:
		factors.append(factors[0])

	return factors

# -------------------------
# Generate Question
# -------------------------
func generate_problem():

	if total_questions >= MAX_QUESTIONS:
		end_test()
		return

	answered = false
	answer_input.editable = true
	submit_button.disabled = false
	next_button.visible = false

	a = randi_range(1, 5)
	b = randi_range(1, 5)

	product_type = randi_range(1, 6)

	match product_type:

		# (ax + b)^2
		1:
			var A = a * a
			var B = 2 * a * b
			var C = b * b

			question_label.text = format_term(A, "x²") + " + " + format_term(B, "x") + " + " + str(C)
			correct_answer = "(" + format_term(a, "x") + "+" + str(b) + ")^2"

		# (ax - b)^2
		2:
			var A = a * a
			var B = 2 * a * b
			var C = b * b

			question_label.text = format_term(A, "x²") + " - " + format_term(B, "x") + " + " + str(C)
			correct_answer = "(" + format_term(a, "x") + "-" + str(b) + ")^2"

		# Difference of squares
		3:
			var A = a * a
			var C = b * b

			question_label.text = format_term(A, "x²") + " - " + str(C)
			correct_answer = "(" + format_term(a, "x") + "+" + str(b) + ")(" + format_term(a, "x") + "-" + str(b) + ")"

		# x² + Bx + C
		4:
			var B = a + b
			var C = a * b

			question_label.text = "x² + " + format_term(B, "x") + " + " + str(C)

			if a == b:
				correct_answer = "(x+" + str(a) + ")^2"
			else:
				correct_answer = "(x+" + str(a) + ")(x+" + str(b) + ")"

		# Sum of cubes
		5:
			question_label.text = format_term(a*a*a, "x³") + " + " + str(b*b*b)
			correct_answer = "(" + format_term(a, "x") + "+" + str(b) + ")(" + format_term(a*a, "x²") + "-" + format_term(a*b, "x") + "+" + str(b*b) + ")"

		# Difference of cubes
		6:
			question_label.text = format_term(a*a*a, "x³") + " - " + str(b*b*b)
			correct_answer = "(" + format_term(a, "x") + "-" + str(b) + ")(" + format_term(a*a, "x²") + "+" + format_term(a*b, "x") + "+" + str(b*b) + ")"

	answer_input.text = ""
	result_label.text = ""


# -------------------------
# Submit (ONE attempt only)
# -------------------------
func on_submit():

	if answered:
		return

	answered = true
	total_questions += 1

	var user_answer = answer_input.text.strip_edges().replace(" ", "")
	var expected = correct_answer.strip_edges().replace(" ", "")

	# Normalize exponents
	user_answer = user_answer.replace("²", "^2").replace("³", "^3")
	expected = expected.replace("²", "^2").replace("³", "^3")

	# Remove 1 coefficient
	user_answer = user_answer.replace("1x", "x")
	expected = expected.replace("1x", "x")

	var correct = false

	var user_factors = get_factors(user_answer)
	var correct_factors = get_factors(expected)

	if user_factors.size() == correct_factors.size():
		user_factors.sort()
		correct_factors.sort()
		
		if user_factors == correct_factors:
			correct = true
	
	if correct:
		result_label.text = "Correct! 🎉"
		score += 1
	else:
		result_label.text = "Incorrect. Correct answer: " + correct_answer.split("|")[0]

	update_score_label()

	answer_input.editable = false
	submit_button.disabled = true
	next_button.visible = true


# -------------------------
# Update Score Label
# -------------------------
func update_score_label():
	score_label.text = "Score: " + str(score) + " / " + str(total_questions)


# -------------------------
# Next Question
# -------------------------
func on_next_question():
	generate_problem()


# -------------------------
# End Test
# -------------------------
func end_test():
	question_label.text = "TEST COMPLETE! 🎉"
	result_label.text = "Final Score: " + str(score) + " / " + str(MAX_QUESTIONS)

	answer_input.visible = false
	submit_button.visible = false
	next_button.visible = false
	
	SaveLoad.contents.player_exp += score
	SaveLoad.contents.factor_score = 0
	SaveLoad.contents.factor_total_questions = 0
	SaveLoad.contents.factor_question_text = ""
	SaveLoad.contents.factor_correct_answer = ""
	SaveLoad._save()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_module_state()
		SaveLoad.contents.player_exp += score
		SaveLoad._save()
		get_tree().quit() 

func _on_button_pressed() -> void:
	SaveLoad.contents.player_exp += score
	SaveLoad._save()
	save_module_state()
	get_tree().change_scene_to_file("res://modules/Factoring and Special Products/main_menu.tscn")
