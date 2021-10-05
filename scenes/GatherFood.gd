extends PanelContainer
signal feeding_completed

const food_item = preload("res://scenes/FoodItem.tscn")

onready var description = $VBoxContainer/PanelContainer/Label
onready var ChoicesContainer = $VBoxContainer/ChoicesContainer
onready var ContinueButton = $VBoxContainer/ContinueButton
onready var FoodBox =$VBoxContainer/ChoicesContainer/FoodBox

func _ready():
	connect("visibility_changed", self, '_on_visibility_changed')
	ContinueButton.connect("pressed", self, "hide")

func _on_visibility_changed() -> void:
	if visible:
		show_text("""
			You rest to scanvage for for you. You'll need to be careful what you feed them...
		""")
		
	else:
		for child in FoodBox.get_children():
			child.queue_free()
		
		for i in range(3):
			FoodBox.add_child(food_item.instance())
		
		description.text = ""
		emit_signal("feeding_completed")

func show_text(text: String) -> void:
	description.text = text.strip_edges().dedent()
	description.visible_characters = 0
	$Tween.interpolate_property(description, 'percent_visible', 0, 1.0, 1/60.0 * text.length())
	$Tween.interpolate_method(self, 'type_out', 0, text.length(), 1/60.0 * text.length())
	$Tween.start()
	yield($Tween, "tween_all_completed")

var old_value = -1
func type_out(value: int) -> void:
	if value % 5 == 0 and old_value != value:
		$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
		$AudioStreamPlayer.play()
		old_value = value
