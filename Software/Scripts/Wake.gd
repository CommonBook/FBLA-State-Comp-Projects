extends Control
# A "wake" is added at startup to parse the saved json information. It includes a loading screen.

@onready var nest : Control = get_parent()
@onready var progress : ProgressBar = $Panel/CenterContainer/ProgressBar

@export var export = false
@onready var file_path : String = OS.get_executable_path().get_base_dir() + "/Partners.json" if export else "res://Runtime/Partners.json"

var busy : bool = true ## Tracks whether the script is still parsing. Used to control loading speed.

signal wake_complete ## Signal fires when the wake has finished its function and begins disappearing. 

var testData = {
	"Godot" : {
		"Members" : {
			"Steve" : {
				"Description" : "This is steve",
				"Phone Number" : 6022222222
			}
		},
		"Type" : "Non-Profit",
		"Custom Tags" : ["Smart", "Cool", "Free", "Open-Source"]
	},
	"Castillo Co." : {
		"Members" : {
			"Castillo" : {
				"Description" : "Castillo is a computer science teacher",
				"Phone Number" : "Not Provided"
			}
		},
		"Type" : "Education",
		"Custom Tags" : ["Cool", "Smart", "Handsome"]
	}
}

var final_data : Dictionary ## Eventually stores the resulting dictionary of data.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("PATH: " + file_path)
	
	# Open json file and parse as text
	var file = FileAccess.open(file_path, FileAccess.READ)
	
	var json_string : String = file.get_as_text()
	
	var json = JSON.new()
	var error = json.parse(json_string) # Parses json_string to json, error stores returned result code
	
	if error == OK:
		if typeof(json.data) == 27:
			final_data = json.data
			push_data()
		else:
			push_error("Incorrect data format. JSON file should contain a dictionary.")
	else:
		push_error("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())

func push_data() -> void: ## Moves the finalized data to the nest of the main scene, then marks the wake as no longer busy
	if nest:
		nest.data = final_data
		nest.JsonPath = file_path
	else:
		push_error("Wake: No owner found.")
	
	busy = false
	emit_signal("wake_complete")


# Called every frame. Controls loading bar appearance and persistence of node and checks if the wake is ready to be removed
func _process(_delta) -> void:
	if progress.value < 100:
		if busy and progress.value > 50:
			progress.value += 0.1
		elif busy:
			progress.value += 0.5
		else:
			progress.value += 2
	elif not busy:
		var mod = Color(modulate.r, modulate.g, modulate.b, (modulate.a-0.05))
		set_modulate(mod)
		
		if mod.a <= 0:
			queue_free()
