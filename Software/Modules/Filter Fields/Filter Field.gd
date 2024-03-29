class_name Filter_Field extends Control
## Combines different 'input changed' signals into one class signal which is recieved by the filters menu.
## 
## This script exists so that I don't need to create more than one script for different input field types
## in the filters editor

var filter_key : String

signal input(input : String, field)

func _on_changed(new_text : String = ""):
	emit_signal("input", new_text, self)
