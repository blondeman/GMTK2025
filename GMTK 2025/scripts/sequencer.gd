extends Control

@export var bpm := 60
@export var beats := 16
@export var tracks := 4

var currentBeat := 0
var lastBeatDelta := 0.0

var trackScene := preload("res://scenes/track.tscn")
@onready var trackContainer := $Panel/trackContainer

func _ready():
	currentBeat = beats - 1
	setTracks()

func setTracks():
	for child in trackContainer.get_children():
		child.queue_free()

	for i in tracks:
		var track = trackScene.instantiate()
		trackContainer.add_child(track)
		track.name = "track_%d" % i
		track.setTrack(beats, "track_%d" % i)

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
		child.setBeat(lastBeat, currentBeat)
