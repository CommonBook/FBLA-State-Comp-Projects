class_name Filters_Window extends Window

var owner_list : Node ## Assigned by instancer. Reference to the [Filterable_List] these filters apply to.

func _ready():
	pass

# Called when a user clicks the X on the popup dialogue.
func _on_close_requested():
	queue_free()
