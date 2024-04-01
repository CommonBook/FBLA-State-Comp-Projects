class_name Pet extends Entity
## A type of animal the player can catch.

@export_range(1,5) var exotic : int = 1 ## How exotic the pet is. The higher the rarer. 

@export var petName : String = "Pet" ## Name of the pet
@export_range(1,4) var petType : int = 1 ## 1: Ground, 2: Air, 3: Aquatic, 4: Insect

@export var navAgent : NavigationAgent2D

var caughtState : bool = false ## Used to queue deletion state.

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
	if caughtState: # If the pet is ever caught, wait for the animation to finish, then destroy.
		if not spriteAnimator.is_playing():
			destroy()

func _physics_process(_delta) -> void:
	
	match petType:
		1: # Ground pet
			ground_physics()
		2: # Air pet
			pass
	
	move_and_slide()

func ground_physics() -> void:
	apply_gravity(baseGravity)
	
