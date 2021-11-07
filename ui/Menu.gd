extends CanvasLayer

onready var start_button = $InitialMenu/VBoxContainer/StartButton
onready var options_button = $InitialMenu/VBoxContainer/OptionsButton
onready var quit_button = $InitialMenu/VBoxContainer/QuitButton

onready var initial_menu = $InitialMenu
onready var options_menu = $OptionsMenu

export(String, FILE, "*.tscn") var initial_level

func _ready():
	start_button.grab_focus()
	start_button.connect("pressed", self, "_on_StartButton_pressed")
	options_button.connect("pressed", self, "_on_OptionsButton_pressed")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")
	options_menu.connect("back_button_pressed", self, "_on_OptionsMenu_back_button_pressed")
	GameManager.reset_game_clock()
	
func _on_StartButton_pressed():
	print("start game")
	GameManager.start_game_clock()
	get_tree().change_scene(initial_level)
	
func _on_OptionsButton_pressed():
	initial_menu.visible = false
	options_menu.visible = true
	print("options menu")
	
	
func _on_QuitButton_pressed():
	print("quit game")
	get_tree().quit()

func _on_OptionsMenu_back_button_pressed():
	initial_menu.visible = true
	options_menu.visible = false
