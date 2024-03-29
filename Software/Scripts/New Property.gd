class_name New_Property_Window extends Window

var parent : Node

var property_name : String
var property_type : String

@export var property_type_selector : OptionButton ## Contains a reference to the dropdown menu.
@export var lineEditEx : LineEdit ## Example input field for LineEdit
@export var textEditEx : TextEdit ## Example input field for TextEdit


func close():
	queue_free()

# Called when the user clicks the X on the popup window.
func _on_close_requested():
	close()

# Called when the user presses 'done'. 
func _on_done_pressed():
	if property_name and property_type:
		parent.add_property(property_name, property_type)
		close()

# Called each time the usre types in the property name field. 
func _on_property_name_text_changed(new_text):
	property_name = new_text

func _on_property_type_item_selected(index):
	property_type = property_type_selector.get_item_text(index).to_lower()
	
	match property_type:
		"manual":
			lineEditEx.show()
			textEditEx.hide()
		"long":
			lineEditEx.hide()
			textEditEx.show()
