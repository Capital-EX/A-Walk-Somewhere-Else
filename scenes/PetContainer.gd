extends ViewportContainer
signal died

var Body: Node2D
var target: String
var state: Dictionary
var dead: bool = false

func _ready() -> void:
	State.connect("state_changed", self, '_on_state_changed')
	self.connect('died', self, '_on_died', [], CONNECT_ONESHOT)

func _on_died() -> void:
	Body.hide()

func _on_state_changed(name, state) -> void:
	if name == target:
		if state.health == 0:
			emit_signal('died')
		
		self.state = state


func can_drop_data(position, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("food") and not dead

func drop_data(position, data):
	var food = data.food
	
	match food.curse:
		Foods.CURSE_NONE:
			state.health = min(state.health + 5, 100)
			state.hunger = max(state.hunger - 10, 0)
		
		Foods.CURSE_RESTORE:
			state.health = min(state.health + 10, 100)
			state.hunger = max(state.hunger - 25, 0)
			
			bless()
			
		Foods.CURSE_TREE, Foods.CURSE_BUG, Foods.CURSE_MUSHROOM:
			state.health = min(state.health + 5, 100)
			state.hunger = max(state.hunger - 10, 0)
			
			give_curse(food.curse)
	
	
	State.update(target, state)
	data.source.queue_free()

func random_curse() -> void:
	give_curse(randi() % 3 + 2)

func give_curse(curse: int) -> void:
	var node = Body.apply_curse(curse)
	if not node:
		emit_signal('died')
		return
		
	Body.frown()
	yield(node.appear(), "completed")
	Body.normal()
	state.curses.append(node)
	

func bless() -> void:
	var node = state.curses.pop_back()
	if node:
		node.dissappear()

func move() -> void:
	for i in range(1, 4):
		$Tween.interpolate_callback(self, 3.0 / 3.0 * i, 'step')
	$Tween.start()

func step() -> void:
	if state.hunger < 100:
		state.hunger += 1
	else:
		state.health -= 1
	
	State.update(target, state)
