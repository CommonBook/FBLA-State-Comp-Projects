extends Tree
@onready var tree = self

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = tree.create_item()
	root.set_text(0,"ROOT")
	tree.hide_root = false
	var child1 = tree.create_item(root)
	var child2 = tree.create_item(root)
	var subchild1 = tree.create_item(child1)
	subchild1.set_text(0, "Subchild1")
