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

@export var filters_menu : PackedScene ## The [PackedScene] containing the popup filters menu
@export var edit_menu : PackedScene ## The [PackedScene] containing the popup edit menu

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
} ## List will await a dictionary which will be stored as listInternal 

var trailing_key : String = "" ## Stores which key in the parent dictionary contains the internal list. For data storage use. Set by initializer. 

@export var title : String = "Title" ## The title to be displayed above the list.
@export var is_editable : bool = true ## Whether the user is able to edit the list.
@export var has_filters : bool = true  ## Whether the user is able to access the filters dialogue.

var filters : Dictionary = {}

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
	listVisual.clear()
	
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

func launch_menu(menu : PackedScene) -> Node: ## Opens a popup menu. Returns reference to that menu.
	var open = menu.instantiate()
	open.owner_list = self
	add_child(open)
	
	return open

# Called when the 'Filters' button is pressed.
func _on_filters_button_pressed():
	print("Opening filters menu for " + title)
	var menu = launch_menu(filters_menu)
	
	menu.apply_filters(filters)

# Called when the edit button is pressed. 
func _on_edit_button_pressed():
	print("Opening edit menu for " + title)
	var menu = launch_menu(edit_menu)

# Checks all items in root data for values under a certain key
func apply_filters(filters_output : Dictionary):
	var filtered_list : Array = []
	
	# Only filter if the filter contents are not empty.
	if filters_output != {}:
	
		listVisual.clear()
		print(filters_output)
		for item in listInternal:
			for filter in filters_output:
				
				# Execute here if the filter is not a list
				if typeof(filters_output[filter]) != TYPE_ARRAY and typeof(filters_output[filter]) != TYPE_PACKED_STRING_ARRAY :
					
					# Check if this item even has this property. If it does not, ignore it. 
					if listInternal[item].has(filter):
						print(filters_output[filter])
						if filters_output[filter].to_lower() in listInternal[item][filter]["value"].to_lower():
							if item not in filtered_list:
								filtered_list.append(item)
							
						else: 
							filtered_list.remove_at(filtered_list.find(item))
							continue
					else: 
						filtered_list.remove_at(filtered_list.find(item))
						continue
				else: # Seperate case for array results
					for value in filters_output[filter]:
						if listInternal[item].has(filter):
							if value in listInternal[item][filter]["value"]:
								if item not in filtered_list:
									filtered_list.append(item)
							else: 
								filtered_list.remove_at(filtered_list.find(item))
								continue
						else: 
							filtered_list.remove_at(filtered_list.find(item))
							continue
	else:
		construct()
	
	# Finally, adds items from filtered list to visual list
	for item in filtered_list:
		listVisual.add_item(item)

