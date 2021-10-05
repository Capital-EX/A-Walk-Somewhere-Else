extends VBoxContainer


func _ready():
	State.connect("state_changed", self, "_on_state_changed")
	
	var state = State.get_state('you')
	$YourHealthLabel.text = "HEALTH: %02d" % state.health
	$YourHungerLabel.text = "HUNGER: %02d" % state.hunger

func _on_state_changed(name: String, state: Dictionary) -> void:
	if name == 'you':
		$YourHealthLabel.text = "HEALTH: %02d" % state.health
		$YourHungerLabel.text = "HUNGER: %02d" % state.hunger
