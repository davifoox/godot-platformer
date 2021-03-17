extends Node

var pressing_left = false
var pressing_right = false
var pressing_up = false
var just_pressed_up = false
var just_released_up = false

func _process(delta):
	_process_input()

func _process_input():
	if OS.get_name() == "Android":
		var accelerometer_value = Input.get_accelerometer().x
		if accelerometer_value < -1:
			pressing_left = true
			pressing_right = false
		elif accelerometer_value > 1:
			pressing_right = true
			pressing_left = false
		else:
			pressing_left = false
			pressing_right = false
			
	else:
		if Input.is_action_pressed("left"):
			pressing_left = true
			pressing_right = false
		elif Input.is_action_pressed("right"):
			pressing_right = true
			pressing_left = false
		if Input.is_action_just_released("left"):
			pressing_left = false
		elif Input.is_action_just_released("right"):
			pressing_right = false

	if Input.is_action_pressed("jump"):
		pressing_up = true
	else:
		pressing_up = false
	
	if Input.is_action_just_pressed("jump"):
		just_pressed_up = true
	else:
		just_pressed_up = false
	
	if Input.is_action_just_released("jump"):
		just_released_up = true
	else:
		just_released_up = false
