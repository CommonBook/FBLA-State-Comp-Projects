class_name Info_Panel extends VBoxContainer

@onready var member_info_tree = $"Member Info"
@onready var full_info = $"Full Info"

@export var hide_names : bool = true

# Transparent function
func assign_member(memberName, member):
	member_info_tree.assign_member(memberName, member)
	full_info.clear()

func _on_member_info_cell_selected():
	var selected = member_info_tree.get_selected()

	var text = selected.get_text(0).split(": ")[1]
	
	if hide_names:
		full_info.text = text
	else:
		full_info.text = selected.get_text(0)
