class_name Pet extends Entity
## A type of animal the player can catch.

@export_range(1,5) var exotic : int = 1 ## How exotic the pet is. The higher the rarer. 

@export var petName : String = "Pet" ## Name of the pet
@export_range(1,4) var petType : int = 1 ## 1: Ground, 2: Air, 3: Aquatic, 4: Insect
@export var reverse_sprite_direction : bool = false

var caughtState : bool = false ## Used to queue deletion state.

@onready var navTimer = $NavTimer
var navigationQueue : Array[Navigation_Task] ## Queue for navigation destinations. Will automatically be carried out.
var navDestination : Vector2
var navigation_complete : bool = true

func _ready():
	if spriteAnimator.sprite_frames.has_animation("Idle"):
		spriteAnimator.play("Idle")
	

func get_sprite() -> SpriteFrames:
	return spriteAnimator.sprite_frames

func caught(projectile : Catching_Item): ## Process to be followed when the pet is caught. 
	print(str(self) + " was caught!")
	
	# Gather info
	var user : Character
	var mult : float = 1
	
	if projectile.has_meta("user"):
		user = projectile.get_meta("user")
	
	if projectile.has_meta("multiplier"):
		mult = projectile.get_meta("multiplier")
	
	# Send off for scoring
	user.score_pet(self, mult)
	
	# Handles state and animation
	caughtState = true
	if spriteAnimator.sprite_frames.has_animation("Caught"):
		spriteAnimator.play("Caught")
	else:
		spriteAnimator.stop()

func destroy() -> void:
	queue_free()

func _on_capture_box_area_entered(area) -> void:
	print(str(area) + " entered " + str(self))
	if area is Catching_Item:
		caught(area)

func _process(_delta) -> void:
	rotate_by_speed(reverse_sprite_direction)
	print(global_position)
	if caughtState: # If the pet is ever caught, wait for the animation to finish, then destroy.
		if not spriteAnimator.is_playing():
			destroy()

func _physics_process(_delta) -> void:
	# During navigation, as long as the timer is going and the pet is not caught
	if not navigation_complete and not caughtState or not navTimer.is_stopped() and not caughtState:
		match petType:
			1:
				walk_to(navDestination)
			2:
				fly_to(navDestination)
		var distance_to_destination = navigationQueue[0].destination.x - position.x
		if distance_to_destination < 1 and distance_to_destination > -1:
			print("Task finished")
			nav_task_finished()
	else:
		move(Vector2.ZERO, groundAcceleration)
	# Decide physics process
	match petType:
		1: # Ground pet
			ground_physics()
		2: # Air pet
			air_physics()
	
	move_and_slide()
	
	if navigation_complete:
		if len(navigationQueue) > 0:
			start_nav_task(navigationQueue[0])
		

func ground_physics() -> void:
	apply_gravity(baseGravity)

func air_physics() -> void:
	apply_friction(airFriction, true)

func walk_to(location : Vector2) -> void:
	var direction = 1 if position.direction_to(location).x > 0 else -1 
	move(Vector2(direction, 0), groundAcceleration) 
	
	if velocity.x == 0 and abs(location.x) > abs(position.x):
		jump()

func fly_to(location : Vector2) -> void:
	velocity = position.direction_to(location) * airAcceleration

func add_navigation_task(location : Vector2, time : int) -> void:
	print("Adding task")
	var navTask = Navigation_Task.new(location, time)
	navigationQueue.append(navTask)

func start_nav_task(navTask : Navigation_Task) -> void:
	navTimer.wait_time = navTask.time_to_reach
	navDestination = navTask.destination
	
	print("Navigating to: " + str(navTask.destination))
	navigation_complete = false
	
	navTimer.start()

func nav_task_finished() -> void:
	navigation_complete = true
	navigationQueue.remove_at(0)
	
	if not navTimer.is_stopped():
		navTimer.stop()

