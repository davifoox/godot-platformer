class_name Idle
extends PlayerState

func physics_update(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 0, player.floor_h_weight)

	if InputManager.pressing_left or InputManager.pressing_right:
		state_machine.transition_to("Run")
	elif InputManager.just_pressed_up:
		state_machine.transition_to("Jump")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
