extends Panel
## Handles the GUI functionality of the edit menu

var filters : Dictionary

signal item_set(info : Dictionary) ## Item : properties ; Contains an item with a series of properties. Will be merged with original data and overwrite.
signal close ## Emitted when the panel has sent its finished result. Tells the window to close

# Get various components
@export var propertyList : ItemList

@export var noneLabel : Label
@export var manualEditor : LineEdit
@export var tagsEditor : TextEdit
@export var longEditor : TextEdit
@export var outputLabel : Label 

var properties_enabled : bool = false
var item_name : String ## Stores the user's item name.
var item_properties : Dictionary = {}## Stores the definitions the user gives each property as a dictionary.
var new_item : Dictionary ## Stores the state of the new item to be added.

var current_key : String ## Tracks the property being modified currently.

func construct(list : Dictionary = filters) -> void: ## Build the list options from the dictionary keys
	if filters:
		for key in filters.keys():
			propertyList.add_item(key)
			item_properties.merge({key : {"value": "N/a",
										"variant": filters[key]} })

func _hide_options() -> void:
	noneLabel.hide()
	manualEditor.hide()
	tagsEditor.hide()
	longEditor.hide()

# Called when an item in the property list is selected.
func _on_item_list_item_selected(index):
	if properties_enabled:
		# Pass key from list to top node.
		current_key = propertyList.get_item_text(index)
		
		_hide_options()
		match filters[current_key]:
			"tags":
				tagsEditor.show()
				if item_properties[current_key]["value"] != "N/a":
					tagsEditor.text = item_properties[current_key]
			"manual":
				manualEditor.show()
				if item_properties[current_key]["value"] != "N/a":
					manualEditor.text = item_properties[current_key]
			"long":
				longEditor.show()
				if item_properties[current_key]["value"] != "N/a":
					longEditor.text = item_properties[current_key]
			"list":
				_hide_options()
				noneLabel.show()
				outputLabel.text = "This data type can not be edited here."
				# Add code to set up options here
	else:
		outputLabel.text = "Please type a name first."

func _store_property_result(input) -> void:
	print("Merging property " + current_key + " as " + str(input))
	item_properties.merge({current_key : input}, true)

# Called when the user types in the name field.
func _on_name_field_text_changed(new_text):
	if not new_text == "":
		properties_enabled = true
	else:
		properties_enabled = false
	
	item_name = new_text

# Called when the LineEdit field is altered.
func _on_manual_editor_text_changed(new_text):
	_store_property_result({"value":new_text,
							"variant":filters[current_key]})

# Called when the tags editor text is changed.
func _on_tags_editor_text_changed():
	var text : String = tagsEditor.text
	var tags_list : PackedStringArray = text.split("; ", false)
	
	_store_property_result({"value":tags_list,
							"variant":filters[current_key]})

# Called when the user presses the 'Finish' button.
func _on_finish_button_pressed():
	outputLabel.text = "Saving item to data."
	
	new_item = {item_name : item_properties}
	emit_signal("item_set", new_item)
	emit_signal("close")

# Called when the user selects a different item on the option editor
func _on_long_editor_text_changed():
	var text : String = longEditor.text
	_store_property_result({"value":text,
							"variant":filters[current_key]})
