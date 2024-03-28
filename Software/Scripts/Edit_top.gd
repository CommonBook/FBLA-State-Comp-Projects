class_name Edit_Window extends Window

var owner_list ## Assigned by initializer. Reference to the parent node.
@onready var filters : Dictionary = owner_list.filters ## Assigned by initializer. Should contains the list of filters from a [Filterable_List]

# Get various components
@onready var titleLabel : Label = $"Nest/Title/CenterContainer/Menu Label"
@onready var newPanel : Node = $"Nest/Choice Panel/New Panel"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Prepare the new item creation panel
	newPanel.connect("close", Callable(self, "_on_close_requested"))
	newPanel.connect("item_set", Callable(self, "_on_item_recieved"))
	newPanel.filters = filters
	newPanel.construct()
	
	# Prepare extra UI elements
	titleLabel.text = owner_list.title

# Called when the user clicks the window's X button.
func _on_close_requested():
	queue_free() # Closes the window

# Called when a property is selected from the list.
func _on_item_recieved(item):
	var main_node = get_tree().get_first_node_in_group("Main")
	var raw_data = main_node.data
	
	# Splits the trailing key in to a series of keys that can be iterated
	var trailing_key = owner_list.trailing_key
	var trailing_keys : Array
	if trailing_key != "":
		trailing_keys = trailing_key.split("/")
		
		# Append 'value' to the list of trailing keys so that the data is added to the info section rather than metadata.
		trailing_keys.append("value")
		
		_find_and_set(raw_data, trailing_keys, item)
	else:
		raw_data.merge(item, true)
	
	main_node.update_data(raw_data)


func _find_and_set(dict : Dictionary, keypath : PackedStringArray, value : Dictionary):
	# Recursively obtain dictionary at path location until no more paths are available
	if len(keypath) > 0:
		var current = keypath[0]
		
		if dict.has(current):
			keypath.remove_at(0)
			print("CURRENT " + str(dict[current]))
			if typeof(dict[current]) == TYPE_STRING:
				dict[current] = {}
			_find_and_set(dict[current],keypath, value) # Recursion happens here, dictionary at position along keypath is passed by reference
			return
	
	else:
		dict.merge(value, true) # Finally, merge at final point
