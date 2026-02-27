extends Control

@onready var question_label = $MarginContainer/VBoxContainer/QuestionLabel
@onready var answer_input   = $MarginContainer/VBoxContainer/AnswerInput
@onready var submit_button  = $MarginContainer/VBoxContainer/SubmitButton
@onready var result_label   = $MarginContainer/VBoxContainer/ResultLabel
@onready var next_button    = $MarginContainer/VBoxContainer/NextQuestionButton

var a: int
var b: int
var correct_answer: String

func _ready():
	randomize()
	submit_button.pressed.connect(on_submit)
	next_button.pressed.connect(on_next_question)

	next_button.visible = false
	generate_problem()


func generate_problem():
	a = randi_range(1, 9)
	b = randi_range(1, 9)

	var B = a + b
	var C = a * b

	question_label.text = "x^2 + " + str(B) + "x + " + str(C)
	correct_answer = "(x + " + str(a) + ")(x + " + str(b) + ")"

	answer_input.text = ""
	result_label.text = ""
	next_button.visible = false


func on_submit():
	var user_answer = answer_input.text.strip_edges().replace(" ", "")
	var expected = correct_answer.strip_edges().replace(" ", "")

	if user_answer == expected:
		result_label.text = "Correct! 🎉"
		next_button.visible = true
	else:
		result_label.text = "Incorrect. Correct answer: " + correct_answer
		next_button.visible = false


func on_next_question():
	generate_problem()
