extends CanvasLayer

var world : Level

@export var dialogues : Array[String] = [""]
var current_dialogue : int = 0

@onready var textBox : Label = $MarginContainer/CenterContainer/Panel/MarginContainer/VBoxContainer/TextBox
@onready var button : Button = $MarginContainer/CenterContainer/Panel/MarginContainer/Continue
@onready var fader : AnimationPlayer = $Fader

# Called when the node enters the scene tree for the first time.
func _ready():
	textBox.text = dialogues[current_dialogue]

func pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
	else:
		get_tree().paused = true

func load_next_text() -> void:
	current_dialogue += 1
	
	if current_dialogue > len(dialogues) - 1:
		return
	
	textBox.text = dialogues[current_dialogue]
	
	match current_dialogue: ## For special events to happen in code based on the line of dialogue you have reached.
		3:
			world.enter_competition()
		4:
			button.disabled = true
			world.moveGate.queue_free()
		5:
			pause()
			button.disabled = false
		7:
			pause()
			button.disabled = true
		8:
			button.disabled = false
		10:
			button.disabled = true
			world.petGate.queue_free()
		11:
			pause()
			button.disabled = false
		16:
			pause()
			world.level_timer.wait_time = 20
			world.level_timer.start()
			fader.play("end")
func _on_continue_pressed():
	load_next_text()
