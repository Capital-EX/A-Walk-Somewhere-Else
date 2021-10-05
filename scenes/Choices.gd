extends PanelContainer
signal choice_made
signal apply_side_effects(choice)

var button_group = ButtonGroup.new()

onready var description = $VBoxContainer/PanelContainer/Label
onready var ChoicesContainer = $VBoxContainer/ChoicesContainer
onready var EffectLabel = $VBoxContainer/PanelContainer2/Label
onready var ConfirmChoiceButton = $VBoxContainer/ConfirmChoiceButton
onready var ContinueButton = $VBoxContainer/ContinueButton
onready var OutComeLabel = $VBoxContainer/ChoicesContainer/MarginContainer/OutComeLabel

func _ready() -> void:
	ConfirmChoiceButton.connect("pressed", self, '_on_choice_made')
	self.connect("visibility_changed", self, "_on_visibility_changed")

func _on_visibility_changed() -> void:
	if not visible:
		for child in ChoicesContainer.get_children():
			if child is Button:
				child.queue_free()
		
		ConfirmChoiceButton.text = "Confirm Choice "
		ConfirmChoiceButton.disabled = true
		description.text = ""
		EffectLabel.text = "You must make a choice."

func show_event(event) -> void:
	var choices = event.get('choices', [])
	if len(choices) == 0:
		ConfirmChoiceButton.text = "Continue your travels "
		yield(show_text(description, Events.get_description(event)), 'completed')
		ConfirmChoiceButton.disabled = false
		yield(ConfirmChoiceButton, "pressed")
	
	else:
		yield(show_text(description, Events.get_description(event)), 'completed')
		for choice in event.choices:
			var button = Button.new()
			button.text = choice.name
			button.size_flags_horizontal = SIZE_SHRINK_CENTER
			button.toggle_mode = true
			button.connect('pressed', self, 'show_choice_description', [choice])
			button.group = button_group
			button.set_meta('choice', choice)
			ChoicesContainer.add_child(button)

func _on_choice_made() -> void:
	var button: Button = button_group.get_pressed_button()
	var choice = button.get_meta('choice')
	var outcome = Events.apply_effect(choice)
	
	for child in ChoicesContainer.get_children():
		if child is Button:
			ChoicesContainer.remove_child(child)
			child.queue_free()
	
	ConfirmChoiceButton.disabled = true
	OutComeLabel.show()
	yield(show_text(OutComeLabel, outcome), 'completed')
	ConfirmChoiceButton.hide()
	ContinueButton.show()
	yield(ContinueButton, "pressed")
	ContinueButton.hide()
	ConfirmChoiceButton.show()
	OutComeLabel.hide()
	hide()
	emit_signal("choice_made")
	
	
	

func show_choice_description(choice: Dictionary) -> void:
	EffectLabel.text = Events.get_choice_info(choice)
	ConfirmChoiceButton.disabled = false

func show_text(target: Label, text: String) -> void:
	target.text = text
	target.visible_characters = 0
	$Tween.interpolate_property(target, 'percent_visible', 0, 1.0, 1/60.0 * text.length())
	$Tween.interpolate_method(self, 'type_out', 0, text.length(), 1/60.0 * text.length())
	$Tween.start()
	yield($Tween, "tween_all_completed")

var old_value = -1
func type_out(value: int) -> void:
	if value % 5 == 0 and old_value != value:
		$AudioStreamPlayer.pitch_scale = rand_range(0.9, 1.1)
		$AudioStreamPlayer.play()
		old_value = value
