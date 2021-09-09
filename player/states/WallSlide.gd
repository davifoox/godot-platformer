class_name WallSlide
extends PlayerState


func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	if player.velocity.y < 0 and Input.is_action_just_released("action1"):
		player.velocity.y *= 0.5
	if player.move_direction == player.wall_direction: #VERDEPOIS definir aqui se quer que sempre fique mais lento ou só quando aperta na direção oposta
		player.velocity.y = clamp(player.velocity.y, -player.gravity, player.gravity * 0.1)
	if Input.is_action_just_pressed("left"):
		player.move_direction = -1
	elif Input.is_action_pressed("right"):
		player.move_direction = 1
	if Input.is_action_just_pressed("action1"):
		player.jump_buffer.start()

	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)

func manage_transition() -> void:
	if player.check_is_on_floor():
		state_machine.transition_to("Idle")
	elif player.move_direction != player.wall_direction:
		state_machine.transition_to("Fall")
	elif player.wall_direction == 0:
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("action1"):# or !player.jump_buffer.is_stopped():
		if player.move_direction == -1:# and !Input.is_action_pressed("left"):
			state_machine.transition_to("WallJump")
		elif player.move_direction == 1:# and !Input.is_action_pressed("right"):
			state_machine.transition_to("WallJump")
	elif player.check_is_on_ledge() == true and player.velocity.y > 0 and player.check_close_to_floor() == false:
		state_machine.transition_to("LedgeGrab")
		
func exit() -> void:
	player.wall_slide_cooldown.start()
