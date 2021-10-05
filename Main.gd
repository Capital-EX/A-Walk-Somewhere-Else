extends Control

var looking_back = true
var first_look_back = true

var can_look_at_body = false
var cat_just_died = false
var dog_just_died = false

var cat_dead = false
var dog_dead = false

var steps_until_event = 1
var encounters = 0

onready var LookBackButton = $HBox/VBoxContainer2/LookBackButton
onready var ProceedButton = $HBox/PanelContainer/ProceedButton
onready var Head = $HBox/PanelContainer/ViewportContainer/Viewport/Background/Head
onready var BG = $HBox/PanelContainer/ViewportContainer/Viewport/Background
onready var Thoughts = $HBox/PanelContainer/CharactersThoughts
onready var YourHouse = $HBox/PanelContainer/ViewportContainer/Viewport/Background/YourHouse
onready var Choices = $HBox/PanelContainer/Choices
onready var GatherFood = $HBox/PanelContainer/GatherFood
onready var YourCat = $HBox/VBoxContainer/VBoxContainer/YourCat
onready var YourDog = $HBox/VBoxContainer/VBoxContainer2/YourDog
onready var You = $HBox/VBoxContainer2/YouImage

func _ready():
	randomize()
	LookBackButton.connect("pressed", self, '_look_back_pressed')
	ProceedButton.connect("pressed", BG, "propagate_call", ['move'])
	ProceedButton.connect("pressed", YourCat, "move")
	ProceedButton.connect("pressed", YourDog, "move")
	ProceedButton.connect("pressed", You, "move")
	ProceedButton.connect("pressed", ProceedButton, 'set_disabled', [true])
	ProceedButton.connect("pressed", LookBackButton, 'set_disabled', [true])
	ProceedButton.connect("pressed", self, "_on_proceed_button_pressed")
	ProceedButton.connect("pressed", YourHouse, "queue_free", [], CONNECT_ONESHOT)
	
	ProceedButton.disabled = true
	LookBackButton.text = "Look Foward"
	Thoughts.think("It's not safe to stay here anymore...")
	
	Events.connect('bless', self, "_on_bless")
	Events.connect('curse', self, '_on_curse')
	
	YourCat.connect("died", self, "_on_cat_died")
	YourDog.connect('died', self, "_on_dog_died")
	You.connect("died", self, "_on_you_died")

func _on_cat_died() -> void:
	cat_dead = true
	$Thud.play()

func _on_dog_died() -> void:
	dog_dead = true
	$Thud.play()

func _on_you_died() -> void:
	$BlackOut.show()
	$Thud.play()
	$Tween.interpolate_method(self, 'fade_out', 0, -80.0, 5)
	$Tween.start()

func _on_bless(who: String):
	match who:
		'cat':
			YourCat.bless()
		
		'dog':
			YourDog.bless()

func _on_curse(who: String):
	match who:
		'cat':
			YourCat.random_curse()
		
		'dog':
			YourDog.random_curse()

func _on_proceed_button_pressed():
	if cat_dead and dog_dead:
		ending()
		return
		
	yield(get_tree().create_timer(3.1), "timeout")
	ProceedButton.disabled = false
	LookBackButton.disabled = false
	steps_until_event -= 1
	
	if steps_until_event == 0:
		LookBackButton.disabled = true
		ProceedButton.disabled = true
		
		
		if randf() > 0.75:
			GatherFood.show()
			yield(GatherFood, "feeding_completed")
			
		else:
			Choices.show_event(Events.get_random_event())
			Choices.show()
			yield(Choices, "choice_made")
		
		ProceedButton.disabled = false
		LookBackButton.disabled = false
		steps_until_event = 1
		encounters += 1

func ending() -> void:
	Thoughts.think("No point in going forwards now...")
	
	ProceedButton.disabled = true
	LookBackButton.disabled = false
	looking_back = true

func _look_back_pressed():
	if cat_dead and dog_dead:
		LookBackButton.disabled = true
		yield(Head, "looked_back")
		ending_walk()
		return
	
	if not looking_back:
		
		looking_back = true
		Head.look_back()
		LookBackButton.disabled = true
		ProceedButton.disabled = true
		yield(Head, "looked_back")
		LookBackButton.disabled = false
		LookBackButton.text = "Look Foward"
		
		if first_look_back:
			Thoughts.think("No point in going back now...")
			first_look_back = false
		
	else:
		looking_back = false
		Head.look_foward()
		LookBackButton.disabled = true
		ProceedButton.disabled = true
		Thoughts.clear_thought()
		yield(Head, "looked_forward")
		LookBackButton.disabled = false
		ProceedButton.disabled = false
		LookBackButton.text = "Look Back"

func ending_walk() -> void:
	get_tree().create_timer(10).connect("timeout", self, 'end_game')
	while true:
		ProceedButton.connect("pressed", BG, "propagate_call", ['move'])
		yield(get_tree().create_timer(3.01), "timeout")


func end_game() -> void:
	$Panel/AnimationPlayer.play("fade_in", -1, -10, true)
	$Tween.interpolate_method(self, 'fade_out', 0, -80, 5)
	$Tween.start()
	yield($Panel/AnimationPlayer,"animation_finished")
	
	

func fade_out(db) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index('Master'), linear2db(db))
