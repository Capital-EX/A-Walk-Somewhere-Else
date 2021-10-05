extends VBoxContainer


func _ready():
	State.connect("state_changed", self, "_on_state_changed")
	
	var state = State.get_state('dog')
	$DogHealthLabel.text = "HEALTH: %02d" % state.health
	$DogHungerLabel.text = "HUNGER: %02d" % state.hunger

func _on_state_changed(name: String, state: Dictionary) -> void:
	if name == 'dog':
		$DogHealthLabel.text = "HEALTH: %02d" % state.health
		$DogHungerLabel.text = "HUNGER: %02d" % state.hunger
