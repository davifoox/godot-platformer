class_name Run
extends PlayerState

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	if Input.is_action_pressed("left"):
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif Input.is_action_pressed("right"):
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	if player.velocity.x != 0:
		player.move_direction = sign(player.velocity.x)
	
	#move
	player.velocity = player.move_and_slide_with_snap(player.velocity,Vector2(0,8), player.floor_normal)
	
	if !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
		state_machine.transition_to("Idle")
	elif player.check_is_on_floor() == false:
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("action1") or !player.jump_buffer.is_stopped():
		state_machine.transition_to("Jump")
