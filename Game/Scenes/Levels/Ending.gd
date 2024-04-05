extends Level

@onready var score_label = $"CanvasLayer/CenterContainer/VBoxContainer/your score"
@onready var highscore_label = $CanvasLayer/CenterContainer/VBoxContainer/highscore

func setup(): ## Disable setup for this stage so that it does not attempt to search for a player or other things. Replace with code for endscreen setup.
	score_label = "Your score: " + str( get_parent().score )
	highscore_label = "High score: " + str( get_parent().highscore )

