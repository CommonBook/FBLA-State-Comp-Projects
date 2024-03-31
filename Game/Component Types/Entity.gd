class_name Entity extends CharacterBody2D

@export_category("Movement Parameters")
@export var moveSpeed : int = 100 ## Maximum speed of the character.
@export var acceleration : int = 100 ## Rate at which character speeds up. 
@export_range(0,1) var friction : float = 0.5 ## Rate at which character is slowed down. 

@export var jumpForce : int = 50 ## Force applied upward when character jumps. 
@export var terminalVelocity : int = 80 ## Maximum y speed of character. 
var jumpReady : bool = false ## Detrmines if a jump is possible. @deprecated

@export_category("World Parameters")
@export var baseGravity : int = 100

@export_category("Components")
@export var spriteAnimator : AnimatedSprite2D

func move(direction : Vector2) -> void: ## Handles character movement when given a direction to move
	# Accelerate
	if direction != Vector2.ZERO:
		velocity += acceleration * direction.normalized()
		
		clamp(velocity.x, -moveSpeed, moveSpeed)
		clamp(velocity.y, -terminalVelocity, terminalVelocity)
	
	# Apply friction
	velocity = lerp(velocity, Vector2(0, velocity.y), friction)
	
	move_and_slide()

func jump() -> void: ## Makes the character jump at the height delimited by its member _jumpForce_
	if is_on_floor():
		velocity.y += -(jumpForce)

func apply_gravity(gravity): ## Applies gravity when given an amount (Try _baseGravity_)
	velocity += Vector2(0, gravity)

func rotate_by_speed() -> void: ## Rotates the _spriteAnimator_ based on the movement direction of the character.
	if spriteAnimator:
		if velocity.x < 0:
			spriteAnimator.flip_h = true
		elif velocity.x > 0:
			spriteAnimator.flip_h = false
