extends Node2D

@onready var transitionLayer = $TransitionLayer
@onready var transitionPlayer = $TransitionLayer/Fader
@export var titleScreen : PackedScene ## Scene containing the title screen

@export var levels : Array[PackedScene] ## Contains the scenes for the [levels] of the game. 
var currentLevel : Level

var score : int ## Total money the player has earned this run. 
var moneyRemaining : int ## The amount of money the player has left in their bank.


func _ready():
	var playButton = $"Main Menu/PlayButton"
	
	playButton.connect("pressed", Callable(self, "play"))

func play() -> void:
	transitionPlayer.play("fade_to_tutorial")



func clear_title():
	var menu = get_tree().get_first_node_in_group("Menu")
	menu.queue_free()

func load_stage(stage : int) -> void:
	if len(levels) - 1 >= stage:
		var level = levels[stage].instantiate()
		
		add_child(level)
		move_child(level, 0)
		
		finished_loading()
	else:
		push_error("Error loading stage: Invalid stage number")

func finished_loading() -> void:
	transitionPlayer.play("fade_in")

func _on_transition_length_timeout():
	transitionLayer.visible = false
