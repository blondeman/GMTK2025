extends GridContainer

@onready var base_scene = preload("res://scenes/base_level.tscn")

func _ready():
	var grid = GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(grid)

	for i in range(count_scenes_in_folder("res://scenes/levels")):
		var btn = Button.new()
		btn.text = "Level " + str(i + 1)
		grid.add_child(btn)
		
		btn.pressed.connect(func():
			load_and_call(i)
		)

func count_scenes_in_folder(folder_path: String) -> int:
	var dir = DirAccess.open(folder_path)
	if not dir:
		push_error("Cannot open folder: " + folder_path)
		return 0

	var count = 0
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tscn"):
			count += 1
		file_name = dir.get_next()
	dir.list_dir_end()

	return count

func load_and_call(index: int):
	var instance = base_scene.instantiate()

	var tree = get_tree()
	var current_scene = tree.current_scene
	tree.root.add_child(instance)
	tree.current_scene = instance

	if current_scene:
		current_scene.queue_free()

	if instance.has_method("load_scene_by_index"):
		instance.load_scene_by_index(index)
