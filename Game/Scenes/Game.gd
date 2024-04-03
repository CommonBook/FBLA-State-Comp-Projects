extends Node2D

@export var titleScreen : PackedScene ## Scene containing the title screen

@export var levels : Array[PackedScene] ## Contains the scenes for the [levels] of the game. 
var currentLevel : Level

func _ready():
	var playButton = $"Main Menu/PlayButton"
	
	playButton.connect("pressed", Callable(self, "play"))

func play() -> void:
	pass
