extends Node2D

var current_level_number
onready var level_number_label = $CanvasLayer/UI/LevelNumberLabel
onready var ui_canvas = $CanvasLayer
onready var pause_menu = $CanvasLayer/PauseMenu
onready var options_menu = $CanvasLayer/OptionsMenu

export(PackedScene) var end_screen


func _ready():
	GameEvents.connect("player_died", self, "_on_player_died")
	pause_menu.connect("options_button_pressed", self, "_on_PauseMenu_options_button_pressed")
	options_menu.connect("back_button_pressed", self, "_on_OptionsMenu_back_button_pressed")
	add_to_group(GameManager.LEVEL_MANAGER_GROUP)
	current_level_number = int(name.lstrip("Level"))
	level_number_label.text = "Lvl " + name.lstrip("Level")

func _input(event):
	if event.is_action_pressed("r"):
		get_tree().reload_current_scene()
		
	if event.is_action_pressed("esc"):
		pause_game()
	
	#Just for Test
	if event.is_action_pressed("ui_accept"):
		load_next_scene()
	#-------------

func load_next_scene():
	if current_level_number < GameManager.total_levels_number:
		var next_level = current_level_number +1
		if next_level < 10:
			next_level = "0" + str(next_level)
		else:
			next_level = str(next_level)
			
		get_tree().change_scene("res://levels/Level" + next_level + ".tscn")
		
	else:
		get_tree().change_scene_to(end_screen)

func pause_game():
	pause_menu.visible = true
	get_tree().paused = true
	
func _on_PauseMenu_options_button_pressed():
	options_menu.visible = true
	pause_menu.visible = false

func _on_OptionsMenu_back_button_pressed():
	options_menu.visible = false
	pause_menu.visible = true

func _on_player_died():
	yield(get_tree().create_timer(0.25), "timeout")
	get_tree().reload_current_scene()
