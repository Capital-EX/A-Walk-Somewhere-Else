extends CenterContainer

onready var label = $Label
onready var tween = $Tween
onready var voice = $AudioStreamPlayer

func think(thought: String) -> void:
	label.percent_visible = 0
	label.text = thought
	tween.interpolate_method(self, '_show_thought', 0, thought.length(), 0.025 * thought.length())
	tween.start()

func clear_thought() -> void:
	tween.interpolate_method(label, 'set_visible_characters', label.text.length(), 0, 1/60.0 * label.text.length())
	tween.start()
	yield(tween, "tween_all_completed")
	label.text = ""

var counter = 0
func _show_thought(value: int) -> void:
	label.visible_characters = value
	if value % 3 == 0:
		voice.pitch_scale = rand_range(0.9, 1.1)
		voice.play()
		
		print(value)
	
