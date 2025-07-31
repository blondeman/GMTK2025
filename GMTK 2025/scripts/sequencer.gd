extends Control

@export var bpm := 60
@export var beats := 16

@export var spawner: Node2D

var currentBeat := 0
var lastBeatDelta := 0.0

var trackScene := preload("res://scenes/track.tscn")
var trackContainerScene := preload("res://scenes/track_container.tscn")

var activeTrack = null

func _ready():
	currentBeat = beats - 1
	setTracks()

func setTracks():
	for child in get_children():
		child.queue_free()

	for i in len(spawner.tracks):
		var trackContainer = trackContainerScene.instantiate()
		add_child(trackContainer)
		trackContainer.visible = false
		
		for trackData in spawner.tracks[i]:
			var track = trackScene.instantiate()
			trackContainer.add_child(track)
			track.name = "track_%d" % i
			track.setTrack(beats, trackData.name, trackData.action, i)
	
	viewTrack(get_child(0))

func viewTrack(track: Control):
	if activeTrack:
		activeTrack.visible = false
	track.visible = true
	activeTrack = track

func _process(delta):
	lastBeatDelta -= delta
	if lastBeatDelta <= 0:
		lastBeatDelta = 60.0 / bpm
		nextBeat()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_1:
			if get_child_count() > 0:
				viewTrack(get_child(0))
		elif event.keycode == KEY_2:
			if get_child_count() > 1:
				viewTrack(get_child(1))
		elif event.keycode == KEY_3:
			if get_child_count() > 2:
				viewTrack(get_child(2))
		elif event.keycode == KEY_4:
			if get_child_count() > 3:
				viewTrack(get_child(3))

func nextBeat():
	var lastBeat = currentBeat
	currentBeat += 1
	if currentBeat >= beats:
		currentBeat = 0
	
	for trackContainer in get_children():
		var codes = []
		var minionId = -1
		for track in trackContainer.get_children():
			minionId = track.minionId
			codes.append(track.setBeat(lastBeat, currentBeat))
		spawner.processMinion(minionId, codes)
