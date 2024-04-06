extends Level

@onready var score_label = $"CanvasLayer/CenterContainer/VBoxContainer/your score"
@onready var highscore_label = $CanvasLayer/CenterContainer/VBoxContainer/highscore

var score
var highscore

func setup(): ## Disable setup for this stage so that it does not attempt to search for a player or other things. Replace with code for endscreen setup.
	score = get_parent().score
	highscore = get_parent().highscore
	
	print(score, highscore)
	
	score_label.text = "Your score: " + str( score )
	highscore_label.text = "High score: " + str( highscore )
	
	save_score()

func _on_restart_pressed():
	if get_parent().has_method("reset"):
		get_parent().reset()
		$Retry.play()
		
		queue_free()

func save_score() -> void:
	if score > highscore:
		get_parent().highscore = score
		get_parent().save_highscore()
