extends Control

var trackScene := preload("res://scenes/track.tscn")
var trackContainerScene := preload("res://scenes/track_container.tscn")

var activeTrack = null
var lastBeat = 0

func setTracks(beats: int, tracks: Array):
	await self.ready
	
	for child in get_children():
		child.queue_free()

	for i in len(tracks):
		var trackContainer = trackContainerScene.instantiate()
		add_child(trackContainer)
		trackContainer.visible = false
		
		for trackData in tracks[i]:
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

func nextBeat(currentBeat: int) -> Array:
	var minionCodes = []
	for trackContainer in get_children():
		var codes = []
		for track in trackContainer.get_children():
			codes.append(track.setBeat(lastBeat, currentBeat))
		minionCodes.append(codes)
	lastBeat = currentBeat
	return minionCodes
