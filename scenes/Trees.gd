extends Spatial

func _ready() -> void:
	var z = -1
	var children = get_children()
	for i in range(0, len(children), 2):
		var tree1 = children[i]
		tree1.frame = randi() % 6
		tree1.translation = Vector3(
			0.95,
			1.28,
			z
		)
		
	
		
		var tree2 = children[i + 1]
		tree2.frame = randi() % 6
		tree2.translation = Vector3(
			-0.95,
			1.28,
			z
		)
		z -= 1
	
	print(z)

