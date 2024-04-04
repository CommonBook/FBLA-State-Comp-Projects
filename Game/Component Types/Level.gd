class_name Level extends Node2D

@export var total_pets : int = 5
@export var level_timer : Timer ## This timer will start at the beginning of a level and determines when the level ends.
@export var move_timer : Timer ## This timer will start at the beginning of a level and decides when all of the pets get a movement opportunity. 

@onready var regions : Array[Node] = get_tree().get_nodes_in_group("Zone")
@onready var player : Player = $Player

func _ready() -> void:
	setup()

func setup() -> void: # Initial setup for when a level is started.
	spread_slots()
	
	if level_timer:
		player.GUI.countdown = level_timer
		level_timer.start()
	
	if move_timer:
		move_timer.start()
		move_timer.connect("timeout", Callable(self, "pets_search"))
		
	if get_parent().is_in_group("Game"):
		get_parent().currentLevel = self
	
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
