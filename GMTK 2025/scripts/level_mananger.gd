extends Node

var scene_paths: Array = []
var loaded_scenes: Array = []
@onready var game_container := $game

var current_scene = 0

func _ready():
	load_all_scenes("res://scenes/levels")

func load_all_scenes(folder_path: String):
	var dir := DirAccess.open(folder_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				var full_path = folder_path + "/" + file_name
				scene_paths.append(full_path)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		push_error("Failed to open folder: " + folder_path)

func load_next_level():
	if current_scene + 1 < len(scene_paths):
		load_scene_by_index(current_scene + 1)
	else:
		print("WIN")

func load_scene_by_index(index: int) -> Node:
	current_scene = index
	
	for child in game_container.get_children():
		child.queue_free()

	if index >= 0 and index < scene_paths.size():
		var packed_scene = load(scene_paths[index])
		if packed_scene is PackedScene:
			var instance = packed_scene.instantiate()
			game_container.add_child(instance)
			loaded_scenes.append(instance)
			return instance
		else:
			push_error("Failed to load PackedScene at index " + str(index))
	else:
		push_error("Invalid scene index: " + str(index))
	return null
