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
	player.apply_gravity(delta)
	if InputManager.just_released_up:
		player.velocity *= 0.5
		
	if player.wall_jump_cooldown.is_stopped():
		state_machine.transition_to("Fall")
	if player.check_is_on_floor():
		if InputManager.pressing_left or InputManager.pressing_right:
			state_machine.transition_to("Run")
		else:
			state_machine.transition_to("Idle")
	if player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")

