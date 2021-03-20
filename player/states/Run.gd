class_name Run
extends PlayerState

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if InputManager.pressing_left:
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif InputManager.pressing_right:
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	
	
	if !InputManager.pressing_left and !InputManager.pressing_right:
		state_machine.transition_to("Idle")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
	elif InputManager.just_pressed_up:
		state_machine.transition_to("Jump")
