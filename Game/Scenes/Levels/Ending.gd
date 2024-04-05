extends Level

@onready var score_label = $"CanvasLayer/CenterContainer/VBoxContainer/your score"
@onready var highscore_label = $CanvasLayer/CenterContainer/VBoxContainer/highscore

func setup(): ## Disable setup for this stage so that it does not attempt to search for a player or other things. Replace with code for endscreen setup.
	var score = get_parent().score
	var highscore = get_parent().highscore
	
	print(score, highscore)
	
	score_label.text = "Your score: " + str( score )
	highscore_label.text = "High score: " + str( highscore )

func _on_restart_pressed():
	if get_parent().has_method("reset"):
		get_parent().reset()
		$Retry.play()
		
		queue_free()
