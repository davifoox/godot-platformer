class_name Run
extends PlayerState

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if Input.is_action_pressed("left"):
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif Input.is_action_pressed("right"):
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	player.move_direction = sign(player.velocity.x)
	
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		state_machine.transition_to("Idle")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("action1") or !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
