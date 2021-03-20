class_name Jump
extends PlayerState

func enter(_msg := {}) -> void:
	player.velocity.y = -player.jump_force

func physics_update(delta: float) -> void:
	player.apply_gravity(delta)
	if InputManager.pressing_left:
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif InputManager.pressing_right:
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	else:
		player.velocity.x = lerp(player.velocity.x , 0, player.air_h_weight)
		
	if !InputManager.pressing_up:
		player.velocity.y *= 0.5
		
	
	if player.velocity.y >= 0:
		state_machine.transition_to("Fall")
	elif player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")
	elif player.hook != null and InputManager.just_pressed_up:
		state_machine.transition_to("Swing")
		

