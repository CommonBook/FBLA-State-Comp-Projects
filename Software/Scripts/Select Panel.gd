extends Panel

@onready var editor : Edit_Window = get_tree().get_first_node_in_group("Editor")

@onready var data : Dictionary = editor.owner_list.listInternal

@export var list : ItemList ## The [ItemList] that the 
@export var editPanel : Property_Editor

var selected_item : String ## Contains the key of the item the user has selected

func _ready():
	
	# Assembles the list of items
	for item in data.keys():
		list.add_item(item)

# Called when an item in the list is selected.
func _on_item_list_item_selected(index):
	selected_item = list.get_item_text(index)
	
	var subdata = data[selected_item]
	
	var item_properties = {}
	# Store item properties
	for property in subdata:
		var info = subdata[property]
		
		if property == "Custom Tags":
			editPanel.tags_text = "; ".join(info["value"])
		
		item_properties.merge({property : info})
	
	# Pass item properties to the editor
	editPanel.item_name = selected_item
	editPanel.item_properties.merge(item_properties, true)
	editPanel.properties_enabled = true
	
	editPanel.construct()
	editPanel.show()
