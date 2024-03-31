class_name Catching_Item extends Area2D
## A itme used to catch pets.
##
## Can be cast by an [Item_Caster]

var size_multiplier : float = 1
var speed_multiplier : float = 1
var direction : int ## Item will fire left if less than zero, right if greater. Will also fire right if equal to zero.
@export var base_cooldown : int = 2 ## Cooldown before modification in seconds
@export var score_multiplier : float = 1 ## Score multiplier for pets caught using this item, if applicable.

func _ready():
	self.set_meta("multiplier", score_multiplier)
