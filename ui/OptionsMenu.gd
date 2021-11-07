extends Control

onready var music_button = $VBoxContainer/MusicButton
onready var sfx_button = $VBoxContainer/SFXButton
onready var back_button = $VBoxContainer/BackButton

signal back_button_pressed

func _ready():
	self.connect("visibility_changed", self, "_on_visibility_changed")
	music_button.connect("pressed", self, "_on_MusicButton_pressed")
	sfx_button.connect("pressed", self, "_on_SFXButton_pressed")
	back_button.connect("pressed", self, "_on_BackButtonn_pressed")
	set_buttons_text()

func _on_visibility_changed():
	if visible:
		music_button.grab_focus()

func _on_MusicButton_pressed():
	GameEvents.emit_signal("music_volume_changed")
	set_buttons_text()
	
func _on_SFXButton_pressed():
	GameEvents.emit_signal("sfx_volume_changed")
	set_buttons_text()
	
func _on_BackButtonn_pressed():
	emit_signal("back_button_pressed")

func set_buttons_text():
	if GameManager.save.music_on:
		music_button.text = "music on"
	else:
		music_button.text = "music off"
		
	if GameManager.save.sfx_on:
		sfx_button.text = "sfx on"
	else:
		sfx_button.text = "sfx off"
		
