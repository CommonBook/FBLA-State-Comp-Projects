class_name Character extends Entity

var score_global_standard = 10 ## The standard by which all pets are scored to. Resulting scoore is a multiple of this.

var item_size_multiplier : float = 1
var item_speed_multiplier : float = 1
var item_cooldown_multiplier : float = 1

var score : int
var exotic_count : Dictionary = {1 : 1,
								2:1,
								3:1,
								4:1,
								5:1}

var petsCaught : Array

func score_pet(pet : Pet, multiplier):
	var exotic_score = pet.exotic
	var random_score_factor = randf_range(0.9,1.2)
	

	var pet_score = _get_pet_score_result(exotic_score, random_score_factor, multiplier)
	
	

## Determines score.
## From the global score standard, multiply by the random factor and rarity score, divided by the number of pets in that rarity. 
func _get_pet_score_result(exotic_score : int, rand_factor : float, multiplier : float):
	return score_global_standard * (exotic_score / exotic_count[exotic_score]) * multiplier
