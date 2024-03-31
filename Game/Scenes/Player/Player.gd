class_name Player extends Character

@export var fallGravityMultiplier : int = 1.8
@export var itemCaster : Item_Caster

func _process(delta):
	# Handle's animations
	if round(velocity.x) == 0:
		spriteAnimator.play("Idle")
	elif velocity.x <= moveSpeed / 2:
		spriteAnimator.play("Walk")
	elif velocity.x > moveSpeed / 2:
		spriteAnimator.play("Run")
	
	rotate_by_speed()


func _physics_process(delta):
	var direction : Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), 0)
	move(direction)
	
	if Input.is_action_just_pressed("ui_up"):
		jump()
	
	if velocity.y <= 0:
		apply_gravity(baseGravity)
	else:
		apply_gravity(baseGravity * fallGravityMultiplier)
	
	##################################
	
	if Input.is_action_just_pressed("control_action"):
		itemCaster.use(round(direction.x))
