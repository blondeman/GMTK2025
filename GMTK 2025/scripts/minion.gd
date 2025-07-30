extends CharacterBody2D

const SPEED = 40.0
@onready var direction = randi_range(-1,1)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = SPEED * direction

	move_and_slide()

func action(actionCode: String):
	print(actionCode)
