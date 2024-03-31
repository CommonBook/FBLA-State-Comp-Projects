extends Catching_Item

@export var rotation_speed : float = 0.1
@export var sprite : Sprite2D

func _ready():
	sprite.flip_h = true if not direction < 0 else false

func _physics_process(_delta):
	rotation += rotation_speed * speed_multiplier * direction
	
