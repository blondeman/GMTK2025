extends CharacterBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -300.0
var direction = 0

var block = false

@onready var noteCol := $note
@onready var blockCol := $block
@onready var noteSpr := $note/Sprite2D
@onready var blockSpr := $block/Sprite2D

func _ready():
	handleBlock()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED * direction

	if block:
		velocity = Vector2.ZERO

	move_and_slide()

func action(actionCodes: Array):
	if "walk_left" in actionCodes:
		direction = -1
	elif "walk_right" in actionCodes:
		direction = 1
	else:
		direction = 0
	
	if "jump" in actionCodes and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if "block" in actionCodes:
		block = !block
		handleBlock()

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
