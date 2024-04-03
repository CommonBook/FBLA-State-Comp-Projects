extends CanvasLayer

# Component references
@onready var netProgress : ProgressBar = $Main/Panel2/MarginContainer/ProgressBar
@onready var moneyLabel : Label = $"Main/Panel/CenterContainer/Money Label"
@onready var plusLabel : Label = $Main/PlusLabel
@onready var animationPlayer : AnimationPlayer = $Main/AnimationPlayer

var score : int = 0 ## Visual version of the score for the display
var scoreToGo : int = 0 ## Amount of score left to count up

var countUp : bool = false ## Controls when the score display starts counting up 

var timerG : Timer ## Reference to the timer recieved for the cooldown

func _process(delta):
	
	if timerG:
		netProgress.value = abs(1 - (timerG.time_left / timerG.wait_time))
	
	if countUp: # Counts up the label on the GUI
		if scoreToGo > 0:
			score += 1
			scoreToGo -= 1
			
			moneyLabel.text = "$" + str(score)
		else:
			countUp = false

func update_score(new_money):
	scoreToGo += new_money
	
	plusLabel.text = "+$" + str(scoreToGo)
	animationPlayer.play("plus_money")
	
	countUp = true

func update_cooldown(timer : Timer):
	timerG = timer
	netProgress.value = int(abs(1 - (timer.time_left / timer.wait_time)))
