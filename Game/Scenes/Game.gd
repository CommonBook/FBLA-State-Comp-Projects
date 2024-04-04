extends Node2D

@onready var transitionLayer = $TransitionLayer
@onready var transitionPlayer = $TransitionLayer/Fader
@export var titleScreen : PackedScene ## Scene containing the title screen

@export var levels : Array[PackedScene] ## Contains the scenes for the [levels] of the game. 
var currentLevel : int
var level_node : Level ## Stores a reference to the level in the scene tree

var score : int ## Total money the player has earned this run. 
var moneyRemaining : int ## The amount of money the player has left in their bank.


func _ready(): ## Sets up any buttons that need it on scene load
	var playButton = $"Main Menu/PlayButton"
	
	playButton.connect("pressed", Callable(self, "play"))

func play() -> void: ## When the play button is pressed, fades out to the tutorial.
	transitionPlayer.play("fade_to_tutorial")

func transition_to_next_stage() -> void: ## Generalized version of loading that fades to the next stage in the order.
	print("transitioning to next stage")
	#transitionLayer.visible = true
	transitionPlayer.play("fade_to_next")

func next() -> void: ## Stage selection for moving to the next stage.
	if len(levels) - 1 >= currentLevel + 1:
		level_node.queue_free()
		currentLevel += 1
		load_stage(currentLevel)

func clear_title(): ## Removes title screen elements.
	var menu = get_tree().get_first_node_in_group("Menu")
	menu.queue_free()

func load_stage(stage : int) -> void: ## Loads a stage into the scene.
	if len(levels) - 1 >= stage:
		var level = levels[stage].instantiate()
		currentLevel = stage
		
		add_child(level)
		move_child(level, 0)
		
		level_node = level
		
		finished_loading()
	else:
		push_error("Error loading stage: Invalid stage number")

func finished_loading() -> void: ## Plays an animation which shows the screen once loading is finished. 
	transitionPlayer.play("fade_in")
