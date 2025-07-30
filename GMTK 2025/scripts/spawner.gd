extends Node2D

var minionScene := preload("res://scenes/minion.tscn")

func _ready():
	spawn()

func spawn():
	for i in 2:
		var minion = minionScene.instantiate()
		minion.name = "minion_%d" % i
		add_child(minion)

func processMinion(id: int, action: String):
	get_node("minion_%d" % id).action(action)
