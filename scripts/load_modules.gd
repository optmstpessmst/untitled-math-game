extends CanvasLayer

@onready var xp_counter := $Panel/VBoxContainer/ExpLabel
@onready var label := $Panel/DialogLabel
@onready var panel := $Panel

var typing_speed := 0.03
var is_typing := false

func _ready():
	panel.hide()
	print("Module Window READY")
	print("Children:", get_children())
	SaveLoad._load()
	var temp = SaveLoad.contents.player_exp
	xp_counter.text = "You currently have " + str(temp) + " experience points! Keep going!"
	

func show_text():
	SaveLoad._load()
	var temp = SaveLoad.contents.player_exp
	xp_counter.text = "You currently have " + str(temp) + " experience points! Keep going!"
	panel.show()
	visible = true

func hide_dialog():
	panel.hide()
	visible = false
