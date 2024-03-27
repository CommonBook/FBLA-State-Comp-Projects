extends Panel
## Handles the GUI functionality of the edit menu

var filters : Dictionary

signal item_set(info : Dictionary) ## Item : properties ; Contains an item with a series of properties. Will be merged with original data and overwrite.

# Get various components
@export var propertyList : ItemList

@export var noneLabel : Label
@export var manualEditor : LineEdit
@export var tagsEditor : TextEdit
@export var optionEditor : OptionButton

func construct(list : Dictionary = filters): ## Build the list options from the dictionary keys
	if filters:
		for key in filters.keys():
			propertyList.add_item(key)



func _hide_options() -> void:
	noneLabel.hide()
	manualEditor.hide()
	tagsEditor.hide()
	optionEditor.hide()

# Called when an item in the property list is selected.
func _on_item_list_item_selected(index):
	# Pass key from list to top node.
	var item_key = propertyList.get_item_text(index)
	
	_hide_options()
	match filters[item_key]:
		"tags":
			tagsEditor.show()
		"manual":
			manualEditor.show()
		"options":
			optionEditor.show()
			# Add code to set up options here
	
