extends Control

# Node paths
@onready var question_label = $MarginContainer/VBoxContainer/QuestionLabel
@onready var answer_input   = $MarginContainer/VBoxContainer/AnswerInput
@onready var submit_button  = $MarginContainer/VBoxContainer/SubmitButton
@onready var result_label   = $MarginContainer/VBoxContainer/ResultLabel
@onready var next_button    = $MarginContainer/VBoxContainer/NextQuestionButton

var correct_answer: String
var a: int
var b: int

func _ready():
	randomize()
	submit_button.pressed.connect(on_submit)
	next_button.pressed.connect(on_next_question)

	next_button.visible = false  # hide next button initially
	generate_problem()


# --- Generate a^2 - b^2 problem ---
func generate_problem():
	a = randi_range(1, 10)  # random a
	b = randi_range(1, 10)  # random b

	# Expanded form: a^2 - b^2
	var A = a*a
	var B = b*b
	question_label.text = str(A) + "x² - " + str(B)

	correct_answer = "(" + str(a) + "x + " + str(b) + ")(" + str(a) + "x - " + str(b) + ")"

	# Clear input/result
	answer_input.text = ""
	result_label.text = ""
	next_button.visible = false  # hide next button until correct


# --- Handle Submit ---
func on_submit():
	var user_answer = answer_input.text.strip_edges().replace(" ", "")
	var expected = correct_answer.strip_edges().replace(" ", "")

	if user_answer == expected:
		result_label.text = "Correct! 🎉"
		next_button.visible = true  # show next button
	else:
		result_label.text = "Incorrect. Correct answer: " + correct_answer
		next_button.visible = false


# --- Next Question Button ---
func on_next_question():
	generate_problem()
