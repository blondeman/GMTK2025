extends Node2D

@export var sequencer: Control
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

var bpm = 120
var beats = 16
var seconds_per_beat = 60.0 / bpm
var next_beat_time = 0.0
var last_playback_time = 0.0

@onready var player: AudioStreamPlayer = $audioPlayer
var currentBeat = 0

func _ready():
	player.play()
	next_beat_time = 0
	sequencer.setTracks(beats, tracks)
	spawn()

func _process(delta):
	var current_time = player.get_playback_position()

	if current_time < last_playback_time:
		loop()
		next_beat_time = seconds_per_beat

	if current_time >= next_beat_time:
		handleBeat()
		next_beat_time += seconds_per_beat

	last_playback_time = current_time

func spawn():
	for i in len(tracks):
		var minion = minionScene.instantiate()
		minion.name = "minion_%d" % i
		add_child(minion)

func processMinion(id: int, codes: Array):
	get_node("minion_%d" % id).action(codes, currentBeat * 2 / beats)

func resetMinions():
	for child in get_children():
		if child.name.begins_with("minion_"):
			child.position = Vector2.ZERO
			child.block = false
			child.handleBlock()

func loop():
	handleBeat()
	resetMinions()

func handleBeat():
	var codes = sequencer.nextBeat(currentBeat)
	for i in len(codes):
		processMinion(i, codes[i])
	
	currentBeat += 1
	if currentBeat >= beats:
		currentBeat = 0
