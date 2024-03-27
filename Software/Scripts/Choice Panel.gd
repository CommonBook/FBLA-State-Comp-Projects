extends Panel
## Controls the display of tree edit panels in the edit menu.

@onready var newPanel : Node = $"New Panel"


# Called when the 'Add New' button is pressed
func _on_add_button_pressed():
	newPanel.show()
	

# Called when the 'Edit Existing' button is pressed
func _on_edit_button_pressed():
	pass # Replace with function body.
