extends CanvasLayer

@onready var label := $Panel/DialogLabel
@onready var panel := $Panel

var typing_speed := 0.03
var is_typing := false

func _ready():
	panel.hide()
	print("Dialog READY")
	print("Children:", get_children())

func show_text(message: String):
	panel.show()
	label.text = message
	visible = true

func hide_dialog():
	panel.hide()
	visible = false
