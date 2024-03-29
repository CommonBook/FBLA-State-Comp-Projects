extends Control
## Main controls the main UI and saves data to the JSON file.

# Get various components.
@export_category("Components")
@export var partnerSearch : Node
@export var memberSerch : Node
@export var partnerDescription : TextEdit
@export var memberInfo : Info_Panel
@export var partner_info : Info_Panel
@export var expand_button : Button

@export_category("Meta")
var JsonPath : String ## String path to the main data file.

var selected_partner : String = "" ## Stores the name of the last selected partner.

var data : Dictionary

func save(): ## Saves the current data dictionary to the JsonPath
	var file = FileAccess.open(JsonPath, FileAccess.WRITE)
	var json = JSON.stringify(data, "\t")
	
	file.store_string(json)

# Called when the wake finishes parsing. Effectively runs once at startup.
func _on_wake_wake_complete():
	construct(partnerSearch)
	
	memberSerch.hide()
	
	partnerSearch.connect("item_selected", Callable(self, "_on_partner_selected"))
	memberSerch.connect("item_selected", Callable(self, "_on_member_selected"))

func construct(list : Node, in_data : Dictionary = data, hold_filters : bool = false) -> void: ## Prepares the main partners list
	list.listInternal = in_data
	
	list.construct()
	if not hold_filters:
		list.parse_filters()

func update_data(input) -> void: ## Reloads startup function with new data
	data = input
	construct(partnerSearch)
	save()

# Called whenever the item selected signal is recieved from the partner search [Filterable_List]
func _on_partner_selected(partner):
	selected_partner = partner
	
	partner_info.assign_member(partner, data[partner])
	
	# Show description
	if data[partner].has("Description"):
		partnerDescription.text = data[partner]["Description"]["value"]
	
	memberSerch.show()
	
	# Activation of member search
	if typeof(data[partner]) == TYPE_DICTIONARY:
		
		var partner_data = data[partner]
		if partner_data.has("Members"):
			if typeof(partner_data["Members"]) == TYPE_DICTIONARY: # Checks if the partner has members
				if partner_data["Members"].has("value"):
					if typeof(partner_data["Members"]["value"]) == TYPE_DICTIONARY: # Ensures correct format of members
						construct(memberSerch, data[partner]["Members"]["value"])
					else:
						construct(memberSerch, {}, true)
		
		memberSerch.trailing_key = "" + str(partner) + "/" + "Members"

# Called whenever the item selected signal is recieved from the member search [Filterable_List]
func _on_member_selected(member):
	memberInfo.assign_member(member, data[selected_partner]["Members"]["value"][member])

# Called when the 'Expand Details' button is pressed. 
func _on_details_pressed():
	if not partner_info.visible:
		partner_info.show()
		expand_button.text = "Collapse Details"
	else:
		partner_info.hide()
		expand_button.text = "Expand Details"
