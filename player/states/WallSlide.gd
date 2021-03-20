class_name WallSlide
extends PlayerState


func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if player.velocity.y < 0 and InputManager.just_released_up:
		player.velocity.y *= 0.5
	if player.move_direction != 0 and player.move_direction == player.wall_direction:
		player.velocity.y = clamp(player.velocity.y, -player.gravity, player.gravity * 0.1)
	
	if player.check_is_on_floor():
		state_machine.transition_to("Idle")
	elif player.move_direction != 0 and player.move_direction != player.wall_direction:
		state_machine.transition_to("Fall")
	elif player.wall_direction == 0:
		state_machine.transition_to("Fall")
	elif InputManager.just_pressed_up:
		state_machine.transition_to("WallJump")
	elif player.check_is_on_ledge() == true and player.velocity.y > 0:
		state_machine.transition_to("GrabLedge")
		
func exit() -> void:
	player.wall_slide_cooldown.start()
