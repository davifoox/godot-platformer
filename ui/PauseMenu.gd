extends Control

onready var continue_button = $VBoxContainer/ContinueButton
onready var restart_button = $VBoxContainer/RestartButton
onready var options_button = $VBoxContainer/OptionsButton
onready var menu_button = $VBoxContainer/MenuButton

signal options_button_pressed

export(PackedScene) var menu

func _ready():
	self.connect("visibility_changed", self, "_on_PauseMenu_visibility_changed")
	continue_button.connect("pressed", self, "_on_continue_button_pressed")
	restart_button.connect("pressed", self, "_on_restart_button_pressed")
	options_button.connect("pressed", self, "_on_options_button_pressed")
	menu_button.connect("pressed", self, "_on_menu_button_pressed")
	
func _on_continue_button_pressed():
	visible = false
	get_tree().paused = false

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_options_button_pressed():
	emit_signal("options_button_pressed")

func _on_menu_button_pressed():
	get_tree().change_scene_to(menu)
	
func _on_PauseMenu_visibility_changed() -> void:
	if visible:
		continue_button.grab_focus()
		
func _exit_tree():
	get_tree().paused = false
