extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
enum State {MOVE, DEAD}
var current_state: State = State.MOVE

func die() -> void:
	if current_state == State.DEAD:
		return
	current_state = State.DEAD

func _physics_process(delta: float) -> void:
	match current_state:
		State.MOVE:
			state_move(delta)
		State.DEAD:
			state_dead(delta)
	
	move_and_slide()

func state_move(delta: float) -> void:
	# Add Gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle the Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the Input Direction.
	var direction := Input.get_axis("move_left", "move_right")
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Apply the Proper Animation.
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("jump")

	# Apply Movement.
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

func state_dead(delta: float) -> void:
	# Apply Gravity (No Need for a Check Since Collision is Turned off)
	velocity += get_gravity() * delta

	# Handle the Animation.
	animated_sprite_2d.play("die")
