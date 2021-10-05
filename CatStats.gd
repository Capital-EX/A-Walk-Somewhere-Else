extends VBoxContainer

func _ready():
	State.connect("state_changed", self, "_on_state_changed")
	
	var state = State.get_state('cat')
	$CatHealthLabel.text = "HEALTH: %02d" % state.health
	$CatHungerLabel.text = "HUNGER: %02d" % state.hunger

func _on_state_changed(name: String, state: Dictionary) -> void:
	if name == 'cat':
		$CatHealthLabel.text = "HEALTH: %02d" % state.health
		$CatHungerLabel.text = "HUNGER: %02d" % state.hunger
