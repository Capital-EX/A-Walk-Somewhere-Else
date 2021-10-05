extends Sprite3D



func _ready():
	pass # Replace with function body.

func move() -> void:
	if translation.z >= 0:
		translation.z = -4 - translation.z
		frame = randi() % 9
	$Tween.interpolate_property(self, "translation:z", translation.z, translation.z + 4, 3.0)
	$Tween.start()
	yield($Tween, "tween_all_completed")
	
