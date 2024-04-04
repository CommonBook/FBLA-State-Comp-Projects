class_name Creature_Zone extends Area2D
## An area in which pets will spawn.
##
## Defines the bounds in which a pet will move, which pets can spawn, and where they can spawn. 

@export var allowed_pets : Array[PackedScene] ## A list of the pets that can spawn according to their scene files. 

@onready var spawnRegion : CollisionShape2D = $SpawnRegion ## The space which will see pets spawned across.
@onready var searchRegion : CollisionShape2D = $SearchRegion ## The navigation region which these pets will be bound to. 

@export var move_chance : int = 4 ## Rarity of a movement opportunity happening for a single pet (Higher is rarer)

var pets : Array[Pet] = [] ## Contains a reference to all of the pets created by this region.

var slots : int = 1

func set_slots(value : int) -> void:
	slots = value 

func spawn_pets() -> void:
	if allowed_pets:
		for i in range(slots):
			var selected_type = allowed_pets[randi_range(0, len(allowed_pets)-1)]
			
			var spawned_pet = selected_type.instantiate()
			
			pets.append(spawned_pet)
			get_parent().get_parent().add_child(spawned_pet)
			
			spawned_pet.global_position = spawnRegion.global_position
		randomize_destinations()

func get_random_position_on_rectangle(rectangle : CollisionShape2D) -> Vector2:
	var size = rectangle.shape.extents
	var positionInArea : Vector2 = Vector2(0, 0)
	
	var area_point = Vector2(rectangle.global_position.x - size.x, rectangle.global_position.y - size.y)
	print(area_point)
	
	positionInArea.x = area_point.x + randi_range(0, 2*size.x)
	positionInArea.y = area_point.y + randi_range(0, 2*size.y)
	print("POS: " + str(positionInArea))
	
	return positionInArea

func randomize_destinations() -> void:
	for pet in pets:
		if pet != null:
			if randi_range(1,10) >= move_chance:
				var destination : Vector2 = get_random_position_on_rectangle(searchRegion) 
				var time = int(3 * (destination.x - pet.global_position.x) / 30)
				
				pet.add_navigation_task(destination, time)
