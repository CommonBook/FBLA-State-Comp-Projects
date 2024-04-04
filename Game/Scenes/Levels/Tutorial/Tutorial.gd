extends Level
## Tutorial script.
##
## Prepares things for the tutorial to happen.

@export var tutorialUI : PackedScene ## Scene with a [CanvasLayer] that contains the text box for the tutorial and other elements it needs.
var tutorialReference : CanvasLayer

@export var moveGate : StaticBody2D
@export var petGate : StaticBody2D
@export var competitorExample : PackedScene ## A scene to represent the competitor.
@export var competitor_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("score_scored", Callable(self, "_on_pet_caught"))
	
	if tutorialUI:
		tutorialReference = tutorialUI.instantiate()
		player.add_child(tutorialReference)
		
		tutorialReference.world = self

func enter_competition() -> void:
	if competitorExample:
		var ref = competitorExample.instantiate()
		ref.position = competitor_pos
		add_child(ref)
		
		$Competition/CPUParticles2D.emitting = true

func _on_tutorial_area_body_entered(body):
	if body is Player and tutorialReference != null:
		tutorialReference.load_next_text()
		if $Tutorial_Area:
			$Tutorial_Area.queue_free()
		else:
			$Tutorial_Area2.queue_free()

func _on_pet_caught(score) -> void:
	tutorialReference.load_next_text()
