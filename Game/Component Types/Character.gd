class_name Character extends Entity

var score_global_standard = 20 ## The standard by which all pets are scored to. Resulting scoore is a multiple of this.

var item_size_multiplier : float = 1
var item_speed_multiplier : float = 1
var item_cooldown_multiplier : float = 1

signal score_scored(new_score)

var score : int = 0
var exotic_count : Dictionary = {1 :0,
								2:0,
								3:0,
								4:0,
								5:0}

var petsCaught : Array[Pet_Scorer] ## Array containing all the pets you have caught as an image and a score. 

func score_pet(pet : Pet, multiplier): ## Gets the score for a pet and stores it in the list, then increments the character's score.
	var exotic_score = pet.exotic
	var random_score_factor = randf_range(0.9,1.2)
	
	exotic_count.merge({exotic_score : exotic_count[exotic_score]+1}, true)
	
	var pet_score = _get_pet_score_result(exotic_score, random_score_factor, multiplier)
	var pet_image = pet.get_sprite()
	
	var result = Pet_Scorer.new(pet_score, pet_image, pet.petName)
	
	petsCaught.append(result)
	score += pet_score
	
	emit_signal("score_scored", pet_score)

## Determines score.
## From the global score standard, multiply by the random factor and rarity score, divided by the number of pets in that rarity. 
func _get_pet_score_result(exotic_score : int, rand_factor : float, multiplier : float) -> int:
	return int(round(score_global_standard * (float(exotic_score) / exotic_count[exotic_score]) * multiplier * rand_factor))
