extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const DASH_SPEED = 400

enum State {MOVE, DASH, DEAD}
var current_state: State = State.MOVE

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var dash_cd_timer: Timer = $DashCooldownTimer
@onready var dash_duration_timer: Timer = $DashDurationTimer

func die() -> void:
	if current_state == State.DEAD:
		return
	current_state = State.DEAD

func _physics_process(delta: float) -> void:
	match current_state:
		State.DASH:
			state_dash(delta)
		State.MOVE:
			state_move(delta)
		State.DEAD:
			state_dead(delta)

	move_and_slide()

func state_move(delta: float) -> void:
	# Check for Dash.
	if Input.is_action_just_pressed("dash") and dash_cd_timer.is_stopped():
		current_state = State.DASH
		dash_duration_timer.start()
		dash_cd_timer.start()
		return

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
	# Turn off Collision so the Player Falls off the Map on Death.
	if collision_shape_2d:
		collision_shape_2d.set_deferred("disabled", true)

	# Apply Gravity.
	velocity += get_gravity() * delta

	# Handle the Animation.
	animated_sprite_2d.play("die")

func state_dash(delta: float) -> void:
	# Play Dash Animation.
	animated_sprite_2d.play("dash")
	velocity.y = 0

	# Handle Dash Movement.
	if animated_sprite_2d.flip_h:
		velocity.x = -DASH_SPEED
	else:
		velocity.x = DASH_SPEED

	# Start Cooldown and Change State Back to Move.
	if dash_duration_timer.is_stopped():
		current_state = State.MOVE
