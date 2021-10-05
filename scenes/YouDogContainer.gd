extends "res://scenes/PetContainer.gd"

func _ready():
	Body = $Viewport/ViewportContainer/CenterContainer/YourDog
	state = State.get_state('dog')
	target = 'dog'
