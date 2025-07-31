extends Node2D

var minionScene := preload("res://scenes/minion.tscn")

@export var tracks := [
	[
		{"action":"walk_left","name":"Walk Left"},
		{"action":"walk_right","name":"Walk Right"},
		{"action":"block","name":"Block"}
	],
	[
		{"action":"walk_left","name":"Walk Left"},
		{"action":"walk_right","name":"Walk Right"},
		{"action":"block","name":"Block"},
		{"action":"jump","name":"Jump"}
	]
]

func _ready():
	spawn()

func spawn():
	for i in len(tracks):
		var minion = minionScene.instantiate()
		minion.name = "minion_%d" % i
		add_child(minion)

func processMinion(id: int, codes: Array):
	get_node("minion_%d" % id).action(codes)

func resetMinions():
	for child in get_children():
		if child.name.begins_with("minion_"):
			child.position = Vector2.ZERO
			child.block = false
			child.handleBlock()
