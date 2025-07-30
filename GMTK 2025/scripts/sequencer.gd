extends Control

@export var bpm := 60
@export var beats := 16
@export var tracks := [
	{"beat":0,"action":"walk","name":"Walk"},
	{"beat":0,"action":"block","name":"Block"},
	{"beat":1,"action":"jump","name":"Jump"},
	{"beat":1,"action":"block","name":"Block"},
]

var currentBeat := 0
var lastBeatDelta := 0.0

var trackScene := preload("res://scenes/track.tscn")
@onready var trackContainer := $trackContainer

func _ready():
	currentBeat = beats - 1
	setTracks()

func setTracks():
	for child in trackContainer.get_children():
		child.queue_free()

	for i in len(tracks):
		var track = trackScene.instantiate()
		trackContainer.add_child(track)
		track.name = "track_%d" % i
		track.setTrack(beats, tracks[i].name, i)

func _process(delta):
	lastBeatDelta -= delta
	if lastBeatDelta <= 0:
		lastBeatDelta = 60.0 / bpm
		nextBeat()

func nextBeat():
	var lastBeat = currentBeat
	currentBeat += 1
	if currentBeat >= beats:
		currentBeat = 0
	
	for child in trackContainer.get_children():
		var actionCode = child.setBeat(lastBeat, currentBeat)
		if actionCode >= 0:
			print(str(tracks[actionCode].beat) + tracks[actionCode].action)
