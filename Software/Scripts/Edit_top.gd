class_name Edit_Window extends Window

var owner_list ## Assigned by initializer. Reference to the parent node.
@onready var filters : Dictionary = owner_list.filters ## Assigned by initializer. Should contains the list of filters from a [Filterable_List]

# Get various components
@onready var newPanel : Node = $"Nest/Choice Panel/New Panel"

# Called when the node enters the scene tree for the first time.
func _ready():
	newPanel.connect("item_selected", Callable(self, "_on_item_selected"))
	newPanel.filters = filters
	newPanel.construct()

# Called when the user clicks the window's X button.
func _on_close_requested():
	queue_free() # Close the window

# Called when a property is selected from the list.
func _on_item_selected(item_key):
	pass
