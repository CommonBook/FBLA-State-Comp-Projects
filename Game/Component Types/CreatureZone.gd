class_name Creature_Zone extends Area2D
## An area in which pets will spawn.
##
## Defines the bounds in which a pet will move, which pets can spawn, and where they can spawn. 

@export var allowed_pets : Array[PackedScene] ## A list of the pets that can spawn according to their scene files. 

@onready var spawnRegion : CollisionShape2D = $SpawnRegion ## The space which will see pets spawned across.
@onready var searchRegion : CollisionShape2D = $SearchRegion ## The navigation region which these pets will be bound to. 

var pets : Array[Pet] = [] ## Contains a reference to all of the pets created by this region.

var slots : int = 1

func set_slots(value : int) -> void:
	slots = value 

func spawn_pets() -> void:
	if allowed_pets:
		for i in range(slots):
			var selected_type = allowed_pets[randi_range(0, len(allowed_pets)-1)]
			
			var positionInArea = get_random_position_on_rectangle(spawnRegion)
			
			var spawned_pet = selected_type.instantiate()
			spawned_pet.position = positionInArea
			add_child(spawned_pet)

func get_random_position_on_rectangle(rectangle : CollisionShape2D) -> Vector2:
	var size = rectangle.shape.extents
	var positionInArea : Vector2 = Vector2(0, 0)
	
	positionInArea.x = randi_range(0, size.x)
	positionInArea.y = randi_range(0, size.y)
	print(positionInArea)
	
	return positionInArea

func randomize_destinations() -> void:
	for pet in pets:
		var destination : Vector2 = get_random_position_on_rectangle(searchRegion) 
		var time = int(3 * (destination.x - pet.global_position.x) / 30)
		
		pet.add_navigation_task(destination, time)
