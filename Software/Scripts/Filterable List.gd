class_name Filterable_List extends VBoxContainer
## A list containing an ItemList which automatically creates filters for properties of items in a dictionary.
##
## The filterable list has two macro-components. The list and the filter. The list is derived from a dictionary [listInternal].
## The attached [ItemList] node will show allow a user to select from any of the first subset of keys in the dictionary. 
## The filters will be automatically generated based on the subchildren of the first 

signal item_selected(item_key)

# Get various components:
@onready var titleLabel : Label = $"Title & Search/Label"
@onready var listVisual : ItemList = $"Names Container/Names List"
@onready var nameSearch : LineEdit = $"Title & Search/Search Field"
@onready var editButton : Button = $"Title & Search/Edit Button"
@onready var filtersButton : Button = $"Title & Search/Filters Button"

@export var filters_menu : PackedScene

var listInternal : Dictionary = { # This dictionary is the default for use in debugging, it should not appear in the final product.
	"Godot" : {
		"Members" : {
			"value" : {
				"Steve" : {
					"Description" : "This is steve",
					"Phone Number" : 6022222222
				}
			},
			"variant" : "list"
		},
		"Type" : {
			"value" : "Non-Profit",
			"variant" : "manual"
		},
		"Custom Tags" : {
			"value" : ["Smart", "Cool", "Free", "Open-Source"],
			"variant" : "tags"
		}
	},
	"Castillo Co." : {
		"Members" : {
			"value" : {
				"Castillo" : {
					"Description" : "Castillo is a computer science teacher",
					"Phone Number" : "Not Provided"
				}
			},
			"variant" : "list"
		},
		"Type" : {
			"value" : "Education",
			"variant" : "manual"
		},
		"Custom Tags" : {
			"value" : ["Cool", "Smart", "Handsome"],
			"variant" : "tags"
		}
	}
}## List will await an dictionary which will be stored as listInternal 

@export var title : String = "Title" ## The title to be displayed above the list.
@export var is_editable : bool = true ## Whether the user is able to edit the list.
@export var has_filters : bool = true  ## Whether the user is able to access the filters dialogue.

var filters : Dictionary = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assign simple properties
	titleLabel.text = title
	
	if is_editable:
		editButton.visible = true
	else:
		editButton.hide()
	
	if has_filters:
		filtersButton.visible = true
	else:
		filtersButton.hide()
	
func parse_filters(): # Parses the JSON for filterable data.
	# Traverse list for items with property dictionaries
	for key in listInternal.keys():
		if typeof(listInternal[key]) == TYPE_DICTIONARY:
			var item = listInternal[key]
			
			# Check item for properties
			for property in item.keys():
				if typeof(item[property]) == TYPE_DICTIONARY:
					var property_dict = item[property]
					
					filters.merge({property : property_dict["variant"]}) # Adds an entry to the filters dictionary containing the name of a property as a key and the variant (type of info input) as its value.

func construct(list = listInternal) -> void: ## Constructs the visual list. 
	listInternal = list
	if list or len(list) > 0:
		var keys : Array = listInternal.keys()
		for key in keys:
			listVisual.add_item(key)

# Called when an item is clicked inside of the ItemList.
func _on_names_list_item_clicked(index, _at_position, _mouse_button_index):
	var selection = listVisual.get_item_text(index)
	
	emit_signal("item_selected", selection)

# Called when a change is made to the search field.
func _on_search_field_text_changed(new_text):
	listVisual.clear()
	if new_text != "":
		for key in listInternal.keys():
			if new_text.to_lower() in key.to_lower():
				listVisual.add_item(key)
	else:
		construct()

# Called when the 'Filters' button is pressed.
func _on_filters_button_pressed():
	print("Opening filters menu for " + title)
	
	var menu = filters_menu.instantiate()
	add_child(menu)
