class_name Pet extends Entity
## A type of animal the player can catch.

@export_range(1,5) var exotic : int = 1 ## How exotic the pet is. The higher the rarer. 

@export var petName : String = "Pet" ## Name of the pet
@export var petType : int = 0 ## 1: Ground, 2: Air, 3: Aquatic, 4: Insect

@export var navAgent : NavigationAgent2D
@export var sprite : Sprite2D

func get_image() -> Texture2D:
	return sprite.texture

func caught(projectile : Catching_Item):
	var user : Character
	var mult : float = 1
	
	if projectile.has_meta("user"):
		user = projectile.get_meta("user")
	
	if projectile.has_meta("multiplier"):
		mult = projectile.get_meta("multiplier")
	
	user.score_pet(self, mult)
