extends TextureRect
signal died

var state = {}

func _ready():
	state = State.get_state('you')
	State.connect("state_changed", self, '_on_state_changed')

func _on_state_changed(name, state):
	if name == 'you':
		self.state = state
		if state.health == 0:
			emit_signal("died")


func can_drop_data(position, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("food")

func drop_data(position, data):
	var food = data.food
	
	match food.curse:
		Foods.CURSE_NONE:
			state.health = min(state.health + 5, 100)
			state.hunger = max(state.hunger - 10, 0)
		
		Foods.CURSE_RESTORE:
			state.health = min(state.health + 10, 100)
			state.hunger = max(state.hunger - 25, 0)
			
			
		Foods.CURSE_TREE, Foods.CURSE_BUG, Foods.CURSE_MUSHROOM:
			state.health = min(state.health + 5, 100)
			state.hunger = max(state.hunger - 2, 0)
	
	State.update('you', state)
	data.source.queue_free()

func move() -> void:
	for i in range(1, 4):
		$Tween.interpolate_callback(self, 3.0 / 3.0 * i, 'step')
	$Tween.start()

func step() -> void:
	if state.hunger < 100:
		state.hunger += 1
	else:
		state.health -= 1
	
	State.update('you', state)
