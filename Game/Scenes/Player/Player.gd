class_name Player extends Character

@export var fallGravityMultiplier : float = 1.8
@export var releaseGravityMultiplier : float = 2.5
@export var itemCaster : Item_Caster

@onready var GUI : CanvasLayer = get_tree().get_first_node_in_group("GUI")
@onready var camera : Camera2D = $Camera2D

signal continue_pressed

func _ready():
	connect("score_scored", Callable(GUI, "update_score"))
	itemCaster.connect("cooldown_started", Callable(GUI, "update_cooldown"))
	camera.make_current()

func _process(delta):
	animate_run()
	rotate_by_speed()

func _physics_process(_delta):
	var direction : Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), 0)
	
	if is_on_floor():
		move(direction, groundAcceleration)
	else:
		move(direction, airAcceleration)
	
	if Input.is_action_just_pressed("ui_up"):
		jump()
	
	if was_on_floor and not is_on_floor() and not velocity.y < 0:
		coyoteTime.start()
	
	
	if velocity.y <= 0 and Input.is_action_pressed("ui_up"):
		apply_gravity(baseGravity * releaseGravityMultiplier)
	elif velocity.y <= 0:
		apply_gravity(baseGravity)
	elif velocity.y > 0:
		apply_gravity(baseGravity * fallGravityMultiplier)
	
	##################################
	
	if Input.is_action_just_pressed("control_action"):
		itemCaster.use(round(direction.x))
