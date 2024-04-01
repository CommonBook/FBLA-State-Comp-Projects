class_name Character extends Entity

var score_global_standard = 10 ## The standard by which all pets are scored to. Resulting scoore is a multiple of this.

var item_size_multiplier : float = 1
var item_speed_multiplier : float = 1
var item_cooldown_multiplier : float = 1

var score : int = 0
var exotic_count : Dictionary = {1 : 1,
								2:1,
								3:1,
								4:1,
								5:1}

var petsCaught : Array

func score_pet(pet : Pet, multiplier): ## Gets the score for a pet and stores it in the list
	var exotic_score = pet.exotic
	var random_score_factor = randf_range(0.9,1.2)
	
	var pet_score = _get_pet_score_result(exotic_score, random_score_factor, multiplier)
	var pet_image = pet.get_image()
	
	var result = Pet_Scorer.new(pet_score, pet_image)
	petsCaught.append(result)
	

## Determines score.
## From the global score standard, multiply by the random factor and rarity score, divided by the number of pets in that rarity. 
func _get_pet_score_result(exotic_score : int, rand_factor : float, multiplier : float):
	return round(score_global_standard * (exotic_score / exotic_count[exotic_score]) * multiplier)
