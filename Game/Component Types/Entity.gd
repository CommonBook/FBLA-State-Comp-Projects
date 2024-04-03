class_name Entity extends CharacterBody2D

@export_category("Movement Parameters")
@export var moveSpeed : int = 50 ## Maximum speed of the character.
@export var groundAcceleration : int = 10 ## Rate at which character speeds up. 
@export var airAcceleration : int = 50
@export_range(0,1) var groundFriction : float = 0.5 ## Rate at which character is slowed down. 
@export_range(0,1) var airFriction : float = 0.3

@export var jumpForce : int = 50 ## Force applied upward when character jumps. 
@export var terminalVelocity : int = 80 ## Maximum y speed of character. 
var jumpReady : bool = false ## Detrmines if a jump is possible. @deprecated

@export_category("World Parameters")
@export var baseGravity : int = 30

@export_category("Components")
@export var spriteAnimator : AnimatedSprite2D
@export var coyoteTime : Timer

var was_on_floor : bool ## Tracks whether the entity was grounded before the last physics call. Used for coyote time.

func move(direction : Vector2, acceleration : int) -> void: ## Handles character movement when given a direction to move
	# Accelerate
	if direction != Vector2.ZERO:
		velocity += acceleration * direction.normalized()
		
	velocity.x = clamp(velocity.x, -moveSpeed, moveSpeed)
	velocity.y = clamp(velocity.y, -terminalVelocity, terminalVelocity)
	
	# Apply friction
	if direction == Vector2.ZERO and is_on_floor():
		apply_friction(groundFriction)
	elif direction == Vector2.ZERO:
		apply_friction(airFriction)
	
	was_on_floor = true if is_on_floor() else false
	
	move_and_slide()

func jump() -> void: ## Makes the character jump at the height delimited by its member _jumpForce_
	if coyoteTime:
		if is_on_floor() or not coyoteTime.is_stopped():
			velocity.y = -(jumpForce)
	else:
		if is_on_floor():
			velocity.y = -(jumpForce)

func apply_gravity(gravity): ## Applies gravity when given an amount (Try _baseGravity_)
	velocity += Vector2(0, gravity)

func apply_friction(friction, vertical : bool = false):
	velocity = lerp(velocity, Vector2(0, velocity.y), friction)
	
	if vertical:
		velocity = lerp(velocity, Vector2.ZERO, friction)

func rotate_by_speed(reverse : bool = false) -> void: ## Rotates the _spriteAnimator_ based on the movement direction of the character.
	if spriteAnimator:
		if velocity.x < 0:
			spriteAnimator.flip_h = true if not reverse else false
		elif velocity.x > 0:
			spriteAnimator.flip_h = false if not reverse else true
