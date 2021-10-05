extends Sprite3D


func move() -> void:
	if translation.z >= 0.0:
		translation.z = -6 - translation.z
		frame = randi() % 6
	
	$Tween.interpolate_property(self, "translation:z", translation.z, translation.z + 4, 3.0)
	$Tween.start()
	
	yield($Tween, "tween_all_completed")
	
