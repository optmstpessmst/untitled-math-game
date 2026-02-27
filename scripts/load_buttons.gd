extends VBoxContainer

func dir_contents(path):
	var directories = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Loading module " + file_name + "...")
				directories.append(file_name)
			file_name = dir.get_next()
	else:
		print("Error occured.")
	
	return directories

func _ready() -> void:
	var directories = dir_contents("res://modules")
	for module in directories:
		if module[0] == '.':
			continue
		print("Loaded module " + module)
		var button = moduleButton.new()  
		button.text = module
		button.pressed.connect(button._linker)
		add_child(button)

func _process(_delta: float) -> void:
	pass
