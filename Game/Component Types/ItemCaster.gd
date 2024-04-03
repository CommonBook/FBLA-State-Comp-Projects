class_name Item_Caster extends Node2D
## Item_Caster casts out an item at the player's location.
##
## That's all it has to do, that is all it will do.

@export_category("Components")
@export var cooldownTimer : Timer

@export_category("Item")
@export var item : PackedScene ## A [PackedScene] containing the [Item] to cast. 
@onready var user : Character = get_parent() ## The item's parent is its user. Should be a character. 

@onready var GUI : CanvasLayer = get_tree().get_first_node_in_group("GUI")
signal cooldown_started(timer : Timer)

func use(direction : int = 1) -> void:
	if not cooldownTimer:
		push_warning(str(self) + " requires a timer!")
	else:
		if cooldownTimer.is_stopped():
			var item_instance = item.instantiate()
			item_instance.set_meta("user", user)
			
			if item_instance is Catching_Item and user is Character:
				item_instance.size_multiplier = float(user.item_size_multiplier)
				item_instance.speed_multiplier = float(user.item_speed_multiplier)
				item_instance.direction = direction if direction < 0 or direction > 0 else 1
				if cooldownTimer:
					cooldownTimer.wait_time = user.item_cooldown_multiplier * item_instance.base_cooldown
			
			add_child(item_instance)
			
			cooldownTimer.start()
			emit_signal("cooldown_started", cooldownTimer)
