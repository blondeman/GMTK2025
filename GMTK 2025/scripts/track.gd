extends HBoxContainer

@onready var beat_template := $beats/template
@onready var beat_container := $beats
@onready var track_label := $PanelContainer/Label

var actionCode := ""
var minionId := -1

func setTrack(numBeats: int, trackName: String, code: String, id: int):
	track_label.text = trackName
	actionCode = code
	minionId = id
	
	for child in beat_container.get_children():
		if child != beat_template:
			beat_container.remove_child(child)
			child.queue_free()

	for i in numBeats - 1:
		var beat = beat_template.duplicate()
		beat.name = "beat_%d" % i
		beat_container.add_child(beat)

func setBeat(lastBeat: int, currentBeat: int) -> String: 
	var last = beat_container.get_child(lastBeat)
	var current = beat_container.get_child(currentBeat)

	var normal_style := StyleBoxFlat.new()
	normal_style.bg_color = Color(0.8, 0.8, 0.8) # gray
	last.add_theme_stylebox_override("normal", normal_style)

	var highlight := StyleBoxFlat.new()
	highlight.bg_color = Color(1, 0.4, 0.4) # red-ish
	current.add_theme_stylebox_override("normal", highlight)
	
	if current.has_method("is_pressed"):
		if current.is_pressed():
			return actionCode
	
	return ""
