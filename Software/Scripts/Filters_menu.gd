class_name Filters_Window extends Window

var owner_list : Node ## Assigned by instancer. Reference to the [Filterable_List] these filters apply to.
var filters : Dictionary

@onready var body : Node = $Nest/Main/VBoxContainer/Body ## Node which each UI element will be parented to.

@export var long_edit_filter_field : PackedScene ## Field used for editing long and tags type data
@export var manual_edit_filter_field : PackedScene ## Field used for editing manual type data

var filter_output : Dictionary = {} ## Stores all of the saved values for the filters, sent out later.

func apply_filters(input_filters):
	filters = input_filters
	owner_list.apply_filters(filter_output)
	
	setup()

func setup():
	# For every filter, set up UI
	for key in filters:
		if not filters[key] == "list":
			# Prepare a label
			var label = Label.new()
			label.text = str(key) + ":"
			
			body.add_child(label)
			
			# Prepare an input field depending on the type
			var scene = anticipate_field(key)
			
			var new_field = scene.instantiate()
			new_field.connect("input", Callable(self, "_field_input_recieved"))
			new_field.filter_key = key
			body.add_child(new_field)

func anticipate_field(field_type) -> PackedScene: ## Determines the type of field that needs to be added for a descriptor
	match filters[field_type]:
		"long":
			return long_edit_filter_field
		"tags":
			return long_edit_filter_field
		"manual":
			return manual_edit_filter_field
	
	return 

func _field_input_recieved(text_input, field_node):
	if field_node is TextEdit:
		text_input = field_node.text
		
		# Makes tags into a list as an exception
		if filters[field_node.filter_key] == "tags":
			if "; " in text_input:
				text_input = text_input.split("; ")
			else:
				text_input = [text_input]
	
	filter_output.merge({field_node.filter_key : text_input}, true)
	
	# If filter is empty, remove from list of filter outputs
	match typeof(text_input):
		TYPE_ARRAY:
			if text_input == [""]:
				print("Removing empty filter: " + str(field_node.filter_key))
				filter_output.erase(field_node.filter_key)
		TYPE_STRING:
			if text_input == "":
				print("Removing empty filter: " + str(field_node.filter_key))
				filter_output.erase(field_node.filter_key)
	
	owner_list.apply_filters(filter_output)

# Called when a user clicks the X on the popup dialogue.
func _on_close_requested():
	queue_free()
