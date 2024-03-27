extends Control

# Get various components.
@export var partnerSearch : Node
@export var memberSerch : Node

var data : Dictionary

func save():
	pass

# Called when the wake finishes parsing.
func _on_wake_wake_complete():
	partnerSearch.construct(data)
	partnerSearch.parse_filters()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
