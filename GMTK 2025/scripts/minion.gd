extends CharacterBody2D

const SPEED = 40.0
var direction = 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED * direction

	move_and_slide()

func action(actionCodes: Array):
	if "walk_left" in actionCodes:
		direction = -1
	elif "walk_right" in actionCodes:
		direction = 1
	else:
		direction = 0
