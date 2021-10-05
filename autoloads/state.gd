extends Node
signal state_changed(name, state)

var state = {}

func _ready() -> void:
	State.register('cat', { health = 100, hunger = 0, curses = [] })
	State.register('dog', { health = 100, hunger = 0, curses = [] })
	State.register('you', { health = 100, hunger = 0 })

func register(name: String, inital_state: Dictionary = {}) -> void:
	state[name] = inital_state

func update(name: String, new_state: Dictionary) -> void:
	merge(state[name], new_state)
	emit_signal('state_changed', name, state[name])
	
func merge(a: Dictionary, b: Dictionary) -> void:
	for key in b:
		a[key] = b[key]

func get_state(name: String) -> Dictionary:
	return state[name].duplicate()
