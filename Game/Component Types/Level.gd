class_name Level extends Node2D

@export_category("Stage Properties")
@export var difficulty : float = 1 ## Higher means more expenses at the end of the day.
@export var total_pets : int = 5 
@export var expense_standard : int = 100 ## Base amount that expenses will be generated from. 

@export_category("Required Stage Components")
@export var level_timer : Timer ## This timer will start at the beginning of a level and determines when the level ends.
@export var move_timer : Timer ## This timer will start at the beginning of a level and decides when all of the pets get a movement opportunity. 

@onready var regions : Array = get_tree().get_nodes_in_group("Zone")
@onready var opponents : Array[Node] = [Node.new()] ## This will later contain all of the competitors.
@onready var player : Player = $Player

func setup() -> void: # Initial setup for when a level is started.
	spread_slots()
	
	regions = get_tree().get_nodes_in_group("Zone")
	opponents = [Node.new()]
	
	if level_timer:
		player.GUI.countdown = level_timer
		level_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
		level_timer.start()
	
	if move_timer:
		move_timer.start()
		move_timer.connect("timeout", Callable(self, "pets_search"))
	
	player.connect("continue_pressed", Callable(get_parent(), "transition_to_next_stage"))
	player.connect("retry_pressed", Callable(get_parent(), "reload_stage"))
	
	spawn_pets()

func pets_search() -> void:
	print("moving")
	for region in regions:
		region.randomize_destinations()

func spread_slots() -> void:
	var slots_per_region = int(total_pets / len(regions))
	
	for region in regions:
		region.slots = slots_per_region

func spawn_pets() -> void:
	for region in regions:
		region.spawn_pets()

func _on_timer_timeout() -> void:
	var earnings = player.score
	var expenses = int(float(difficulty) * (float(len(opponents)) / 2) * float(expense_standard))
	var score = earnings - expenses
	
	print(int(float(difficulty) * (float(len(opponents)) / 2) * float(expense_standard)))
	print("Earned: " + str(earnings))
	print("Lost: " + str(expenses))
	
	var GUI = player.GUI
	
	GUI.earningLabel.text = "$" + str(earnings)
	GUI.expensesLabel.text = "$" + str(expenses)
	
	var fail : bool
	if get_parent().is_in_group("Game"):
		
		get_parent().score += earnings
		fail = get_parent().moneyRemaining + score < 0
		
		if not fail:
			get_parent().moneyRemaining += score
			GUI.resultLabel.text = "$" + str(get_parent().moneyRemaining)
		else:
			GUI.resultLabel.text = "$" + str(get_parent().moneyRemaining + score)
			get_parent().score -= earnings
		
		
	
	if fail:
		GUI.animationPlayer.play("finish_L")
		# Change animation to show a different retry button, then add a different method to game for that
	else:
		GUI.animationPlayer.play("finish_W")
