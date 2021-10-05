extends Spatial

const DecorScene = preload("res://scenes/Decoration.tscn")

var object_pool = []

func _ready():
	for i in range(1, 200):
		var decor = DecorScene.instance()
		decor.frame = randi() % 9
		decor.translation = Vector3(
			rand_range(-0.6, -0.9) if randf() > 0.5 else rand_range(0.6, 0.9),
			0.0, 
			rand_range(0, -8)
		)
		add_child(decor)
