class_name Fall
extends PlayerState

var air_h_weight: float

func enter(_msg := {}) -> void:
	if state_machine.last_state_name == "WallJump":
		air_h_weight = player.air_h_weight_after_wall_jump
	else:
		air_h_weight = player.air_h_weight_regular
	if state_machine.last_state_name == "Run":
		player.coyote_timer.start()

func physics_update(delta: float) -> void:
	if InputManager.pressing_left:
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif InputManager.pressing_right:
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	else:
		player.velocity.x = lerp(player.velocity.x , 0, air_h_weight)
	
	if player.check_is_on_floor():
		state_machine.transition_to("Idle")
	elif !player.coyote_timer.is_stopped() and InputManager.just_pressed_up:
		state_machine.transition_to("Jump")
	elif player.wall_direction != 0 and player.wall_slide_cooldown.is_stopped():
		state_machine.transition_to("WallSlide")
	elif !player.wall_slide_cooldown.is_stopped() and InputManager.just_pressed_up and player.move_direction != 0:
		state_machine.transition_to("WallJump")
