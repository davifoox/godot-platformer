extends Node2D

func _ready():
	GameEvents.connect("player_died", self, "_on_player_died")

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_R) and just_pressed:
		get_tree().reload_current_scene()

func _on_player_died():
	get_tree().reload_current_scene()
