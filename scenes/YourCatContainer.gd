extends "res://scenes/PetContainer.gd"

func _ready():
	Body = $Viewport/ViewportContainer/CenterContainer/YourCat
	state = State.get_state('cat')
	target = 'cat'
