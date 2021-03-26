class_name WallJump
extends PlayerState


func enter(_msg := {}) -> void:
	var wall_jump_force = player.wall_jump_velocity
	if state_machine.last_state_name == "WallSlide":
		wall_jump_force.x *= -player.wall_direction
	elif state_machine.last_state_name == "Fall":
		wall_jump_force.x *= player.move_direction
	player.velocity = wall_jump_force
	player.wall_jump_cooldown.start()

func physics_update(delta: float) -> void:
	#apply gravity
	player.velocity.y += player.gravity * delta
	player.velocity.y = clamp(player.velocity.y, -player.gravity, player.max_y_velocity)
	
	if Input.is_action_just_released("action1"):
		player.velocity *= 0.5
	if player.velocity.x != 0:
		player.move_direction = sign(player.velocity.x)

	#move
	player.velocity = player.move_and_slide(player.velocity, player.floor_normal)

func manage_transition() -> void:
	if player.wall_jump_cooldown.is_stopped():
		state_machine.transition_to("Fall")
	if player.check_is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
	if player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")
