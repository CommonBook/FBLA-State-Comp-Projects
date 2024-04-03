class_name Level extends Node2D

@export var total_pets : int = 5
@onready var regions : Array[Node] = get_tree().get_nodes_in_group("Zone")

func _ready() -> void:
	spread_slots()
	
	if get_parent().is_in_group("Game"):
		get_parent().currentLevel = self

func spread_slots() -> void:
	
	var slots_per_region = int(total_pets / len(regions))
	
	for region in regions:
		region.slots = slots_per_region

func spawn_pets() -> void:
	for region in regions:
		spawn_pets()
