class_name Jump
extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity.y = -player.jump_force

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	if Input.is_action_pressed("left"):
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif Input.is_action_pressed("right"):
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	else:
		player.velocity.x = lerp(player.velocity.x , 0, player.air_h_weight)
	if player.velocity.x != 0:
		player.move_direction = sign(player.velocity.x)
	if !Input.is_action_pressed("action1"):
		player.velocity.y *= 0.5
	if Input.is_action_just_pressed("action1"):
		player.jump_buffer.start()
	
	if player.velocity.y >= 0:
		state_machine.transition_to("Fall")
	elif player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")
	elif player.hook != null and Input.is_action_just_pressed("action1"):
		state_machine.transition_to("Swing")
