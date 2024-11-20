extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = 400
@export var FLOOR_DETECTION_RANGE = 5

@export var camera: Camera2D;
@export var animation_sprite: AnimatedSprite2D;

@export var rayLeft: RayCast2D;
@export var rayRight: RayCast2D;

var isAttacking = false

func _ready() -> void:
	rayLeft.position.x = -FLOOR_DETECTION_RANGE
	rayLeft.position.y = 14
	rayRight.position.x = FLOOR_DETECTION_RANGE
	rayRight.position.y = 14

func _physics_process(delta: float) -> void:
	handleAttack()

	if not isAttacking:
		handleGravity(delta)
		handleJump(delta)
		handleMovement(delta)

	move_and_slide()

func handleGravity(delta: float) -> void: 
	if not (rayLeft.is_colliding() or rayRight.is_colliding()):
		velocity += get_gravity() * delta

func handleJump(delta: float) -> void:
	if Input.is_action_just_pressed("Jump") and (rayLeft.is_colliding() or rayRight.is_colliding()):
		velocity.y = JUMP_VELOCITY * -1

func handleMovement(delta: float) -> void:
	var direction := Input.get_axis("Left", "Right")
	
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, delta * 10.0)
	else:
		velocity.x = lerp(velocity.x, move_toward(velocity.x, 0, SPEED), delta * 10.0)

	# Flip sprite
	animation_sprite.flip_h = velocity.x < 0
	
func handleAttack() -> void:
	if Input.is_action_just_pressed("Attack") and (rayLeft.is_colliding() or rayRight.is_colliding()):
		isAttacking = true
		velocity.x = 0
		await get_tree().create_timer(0.4).timeout
		isAttacking = false
