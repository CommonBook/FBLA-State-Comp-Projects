extends CanvasLayer

# Component references
@onready var netProgress : ProgressBar = $Main/Panel2/MarginContainer/ProgressBar
@onready var moneyLabel : Label = $"Main/Panel/CenterContainer/Money Label"
@onready var plusLabel : Label = $Main/PlusLabel
@onready var animationPlayer : AnimationPlayer = $Main/AnimationPlayer

var score : int = 0 ## Visual version of the score for the display
var scoreToGo : int = 0 ## Amount of score left to count up

var countUp : bool = false ## Controls when the score display starts counting up 

var percentTimer : Timer ## Reference to the timer recieved for the cooldown

@onready var countdown : Timer
@onready var countdownText : Label = $Main/CenterContainer/CountdownText
@onready var countdownAnimator : AnimationPlayer = $Main/CenterContainer/CountdownAnimator

var timer_timer : float = 0 ## Counts up and resets every second. Determines when the timer text is updated.

func _ready():
	countdownAnimator.play("Wiggle")

func _process(delta):
	timer_timer += delta
	if timer_timer >= 1:
		timer_timer = 0
		if countdown:
			update_timer(countdown)
	
	if percentTimer:
		netProgress.value = abs(1 - (percentTimer.time_left / percentTimer.wait_time))
	
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
	percentTimer = timer
	netProgress.value = int(abs(1 - (timer.time_left / timer.wait_time)))

func update_timer(timer):
	countdown = timer
	if countdown.time_left > 0:
		countdownText.text = str(round(countdown.time_left)) + "!"
	else:
		countdownText.text = "Time's up!!!"
	
	if countdown.time_left < 10: 
		countdownText.label_settings.font_color = Color(1,0.1,0.1,1)
