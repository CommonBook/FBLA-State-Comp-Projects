extends Catching_Item

@export var rotation_speed : float = 1
@export var sprite : Sprite2D

var rotation_objective : float

func _ready():
	sprite.flip_h = true if not direction < 0 else false
	
	rotation_objective = rotation + deg_to_rad(90 * direction)

func _physics_process(_delta):
	if direction < 0:
		if rotation > rotation_objective:
			spin()
		else:
			queue_free()
	else:
		if rotation < rotation_objective:
			spin()
		else:
			print("bye-bye")
			queue_free()

func spin() -> void:
	rotation += deg_to_rad(rotation_speed) * speed_multiplier * direction
