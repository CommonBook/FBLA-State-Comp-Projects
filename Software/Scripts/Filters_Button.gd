extends Button

@export var filters_menu : PackedScene ## The scene containing the menu that the button will open as a scene.

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed():
	print("Opening filters menu for _")
	
	var menu = filters_menu.instantiate()
	add_child(menu)
