class_name Idle
extends PlayerState

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	player.velocity.x = lerp(player.velocity.x, 0, player.floor_h_weight)

	if Input.is_action_pressed("left"):
		state_machine.transition_to("Run")
	elif Input.is_action_pressed("right"):
		state_machine.transition_to("Run")
	elif Input.is_action_just_pressed("action1") or !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
