extends Node2D

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_R) and just_pressed:
		get_tree().reload_current_scene()
