class_name Navigation_Task extends Resource

var destination : Vector2 ## Point in space the pet will try to navigat to. Note: Pet does not pathfind around walls.
var time_to_reach : int ## Time in seconds until the navigation task will time out and be cancelled. 

func _init(location : Vector2, time : int):
	destination = location
	time_to_reach = time
