extends Camera
signal looked_back
signal looked_forward

const STEPS = 12

onready var left = $AudioStreamPlayer
onready var right = $AudioStreamPlayer2

func move() -> void:
	var step_duration = 3.0 / (STEPS)
	for i in range(0, STEPS, 2):
		$Tween.interpolate_property(self, 'translation:y', translation.y, translation.y + 0.05, step_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, step_duration * i)
		$Tween.interpolate_property(self, 'translation:y', translation.y + 0.05, translation.y, step_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, (i + 1) * step_duration)
		print()
		$Tween.interpolate_callback(self, (i + 1) * step_duration, 'play')
	$Tween.start()

var c = 0
func play() -> void:
	[left, right][c % 2].play()
	c += 1

func look_back() -> void:
	$Tween2.remove(self, 'rotation_degrees:y')
	$Tween2.interpolate_property(self, 'rotation_degrees:y', rotation_degrees.y, 180, 1)
	$Tween2.start()
	yield($Tween2, "tween_all_completed")
	emit_signal("looked_back")
	

func look_foward() -> void:
	$Tween2.remove(self, 'rotation_degrees:y')
	$Tween2.interpolate_property(self, 'rotation_degrees:y', rotation_degrees.y, 0, 1)
	$Tween2.start()
	yield($Tween2, "tween_all_completed")
	emit_signal("looked_forward")
