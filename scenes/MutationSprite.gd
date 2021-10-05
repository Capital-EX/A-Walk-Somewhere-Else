extends Sprite


func appear() -> void:
	$AnimationPlayer.play("appear")
	yield($AnimationPlayer, "animation_finished")

func dissappear() -> void:
	$AnimationPlayer.play_backwards("appear")
