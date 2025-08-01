extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -300.0
var direction = 0

var block = false

@onready var noteCol := $note
@onready var blockCol := $block
@onready var noteSpr := $note/Sprite2D
@onready var blockSpr := $block/Sprite2D

@onready var player := $OneNote

var pitches := [
	[0, 4, 7, 12],
	[2, 6, 9, 14]
]

func _ready():
	handleBlock()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED * direction

	if block:
		velocity = Vector2.ZERO

	move_and_slide()

func action(actionCodes: Array, pitchType: int):
	if "walk_left" in actionCodes:
		direction = -1
		player.pitch_scale = getPitch(pitchType, 0)
		player.play()
	elif "walk_right" in actionCodes:
		direction = 1
		player.pitch_scale = getPitch(pitchType, 1)
		player.play()
	else:
		direction = 0
	
	if "block" in actionCodes:
		block = !block
		handleBlock()
		player.pitch_scale = getPitch(pitchType, 2)
		player.play()
	
	if "jump" in actionCodes and is_on_floor():
		velocity.y = JUMP_VELOCITY
		player.pitch_scale = getPitch(pitchType, 3)
		player.play()

func getPitch(type: int, id: int) -> float:
	return 1.0 * pow(2, pitches[type][id] / 12.0)

func handleBlock():
	if not block:
		set_collision_layer_value(1, false)
		noteCol.disabled = false
		noteSpr.visible = true
		
		blockCol.disabled = true
		blockSpr.visible = false
	else:
		set_collision_layer_value(1, true)
		noteCol.disabled = true
		noteSpr.visible = false
		
		blockCol.disabled = false
		blockSpr.visible = true
