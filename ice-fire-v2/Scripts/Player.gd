extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 400

@export var camera: Camera2D;
@export var animation_sprite: AnimatedSprite2D;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY * -1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, delta * 5.0)
	else:
		velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, SPEED), delta * 5.0)

	animation_sprite.flip_h = velocity.x < 0

	move_and_slide()
