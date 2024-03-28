extends Tree
@onready var tree = self

var member : Dictionary = {}
var memberName : String = ""

func assign_member(member_name, member_dict) -> void: ## Proxy function to assign values to this object
	member = member_dict
	memberName = member_name
	
	_on_member_changed()

func _on_member_changed(): ## Decorates the tree
	tree.clear()
	
	var root = tree.create_item()
	root.set_text(0, memberName + ":")
	tree.hide_root = false
	
	for key in member:
		var value = member[key]["value"]
		
		var child = tree.create_item(root)
		child.set_text(0, key + ": \t" + str(value))


