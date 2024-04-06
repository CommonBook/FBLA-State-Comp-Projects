extends Node2D

@onready var transitionLayer = $TransitionLayer
@onready var transitionPlayer = $TransitionLayer/Fader
@onready var saveDirectory : String = "user://save/"
var saveFilename : String = "player_data.tres"
@export var titleScreen : PackedScene ## Scene containing the title screen

@export_category("Audio")
@export var bgm : AudioStreamPlayer2D ## The audio stream player playing the background music
@export var playSound : AudioStreamPlayer2D ## Thea audio stream player to play the sound when the play button is pressed

@export var levels : Array[PackedScene] ## Contains the scenes for the [levels] of the game. 
var currentLevel : int
var level_node : Level ## Stores a reference to the level in the scene tree

var score : int ## Total money the player has earned this run. 
var moneyRemaining : int ## The amount of money the player has left in their bank.

var save_data : Resource 
var highscore : int ## Stores the player's high score.

func _ready(): ## Sets up any buttons that need it on scene load
	DirAccess.make_dir_absolute(saveDirectory)
	
	var playButton = $"Main Menu/PlayButton"
	playButton.connect("pressed", Callable(self, "play"))
	
	highscore = load_highscore()

func save_highscore() -> void:
	ResourceSaver.save(Save_Data.new(highscore), saveDirectory + saveFilename)

func load_highscore() -> int:
	#save_highscore()
	if FileAccess.file_exists(saveDirectory + saveFilename):
		save_data = ResourceLoader.load(saveDirectory + saveFilename, "Save_Data").duplicate(true)
	else:
		save_highscore()
	
	if save_data:
		print(save_data.highscore)
		return save_data.highscore
	else:
		return 0


func reset() -> void: ## Completely resets the game properties.
	currentLevel = 0
	score = 0
	moneyRemaining = 0
	play()

func play() -> void: ## When the play button is pressed, fades out to the tutorial.
	if playSound:
		playSound.play()
	bgm.stop()
	transitionPlayer.play("fade_to_tutorial")

func transition_to_next_stage() -> void: ## Generalized version of loading that fades to the next stage in the order.
	print("transitioning to next stage")
	#transitionLayer.visible = true
	transitionPlayer.play("fade_to_next")

func next() -> void: ## Stage selection for moving to the next stage.
	if len(levels) - 1 >= currentLevel + 1:
		remove_child(level_node)
		currentLevel += 1
		load_stage(currentLevel)

func clear_title(): ## Removes title screen elements.
	var menu = get_tree().get_first_node_in_group("Menu")
	remove_child(menu)

func reload_stage() -> void: ## Resets the current stage.
	currentLevel -= 1
	transition_to_next_stage()

func load_stage(stage : int) -> void: ## Loads a stage into the scene.
	if len(levels) - 1 >= stage:
		var level = levels[stage].instantiate()
		currentLevel = stage
		
		add_child(level)
		move_child(level, 0)
		
		level.setup()
		level_node = level
		
		finished_loading()
	else:
		push_error("Error loading stage: Invalid stage number")

func finished_loading() -> void: ## Plays an animation which shows the screen once loading is finished. 
	transitionPlayer.play("fade_in")
