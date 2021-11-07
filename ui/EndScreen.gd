extends Node

var game_clock_result = ""
export(PackedScene) var menu

func _ready():
	GameManager.stop_game_clock()
	game_clock_result = GameManager.get_game_clock_result()
	print(game_clock_result)
	
	$MenuButton.connect("pressed", self, "_on_MenuButton_pressed")
	$MenuButton.grab_focus()

func _on_MenuButton_pressed():
	get_tree().change_scene_to(menu)
