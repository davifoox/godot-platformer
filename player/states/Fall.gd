class_name Fall
extends PlayerState

func physics_update(delta: float) -> void:
	if InputManager.pressing_left:
		player.velocity.x = max(player.velocity.x - player.acc * delta, -player.max_speed)
	elif InputManager.pressing_right:
		player.velocity.x = min(player.velocity.x + player.acc * delta, player.max_speed)
	else:
		player.velocity.x = lerp(player.velocity.x , 0, player.air_h_weight)
	
	if player.check_is_on_floor():
		state_machine.transition_to("Idle")
